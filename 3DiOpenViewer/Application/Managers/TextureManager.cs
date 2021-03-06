/*
 * Copyright (c) 2008-2009, 3Di, Inc. (http://3di.jp/) and contributors.
 * See CONTRIBUTORS.TXT for a full list of copyright holders.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of 3Di, Inc., nor the name of the 3Di Viewer
 *       "Rei" project, nor the names of its contributors may be used to
 *       endorse or promote products derived from this software without
 *       specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY 3Di, Inc. AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 3Di, Inc. OR THE
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * Additionally, portions of this file bear the following BSD-style license
 * from the IdealistViewer project (URL http://idealistviewer.org/):
 * 
 * Copyright (c) Contributors, http://idealistviewer.org/
 * See CONTRIBUTORS.TXT for a full list of copyright holders.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the OpenViewer Project nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE DEVELOPERS ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define DebugTexturePipeline
using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.IO;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;
using System.Xml.Serialization;
using OpenMetaverse;
using OpenSim.Framework;
//using OpenMetaverse.Rendering;
using IrrlichtNETCP;
using Amib.Threading;

namespace OpenViewer.Managers
{
    
    /// <summary>
    /// Texture Callback for when we've got the texture
    /// </summary>
    /// <param name="texname"></param>
    /// <param name="node"></param>
    /// <param name="AssetID"></param>
    public delegate void TextureCallback(string texname, string extension, VObject node, UUID AssetID);

    public enum TextureDownloadStyle
    {
        TEX_DOWNLOAD_LIBOMV,
        TEX_DOWNLOAD_ASSETSERVER
    };

    /// <summary>
    /// Handles General texture work.  Downloading, requesting, managing duplicates etc.
    /// </summary>
    public class TextureManager : BaseManager
    {
        private class TextureDownloadRequest
        {
           public UUID uuid;
        }
        public TextureDownloadStyle texDownloadStyle = TextureDownloadStyle.TEX_DOWNLOAD_ASSETSERVER; // TEX_DOWNLOAD_LIBOMV; 
        public Dictionary<UUID, long[]> downloadQueue = new Dictionary<UUID, long[]>();
        public event TextureCallback OnTextureLoaded;

        private Viewer viewer = null;
        private VideoDriver driver = null;
        private string imagefolder = string.Empty;
        private bool shaderYN = true;
        private int newMaterialType1 = 0;

        /// <summary>
        /// In Memory texture cache
        /// </summary>
        private Dictionary<UUID, TextureExtended> memoryTextures = new Dictionary<UUID, TextureExtended>();
        
        /// <summary>
        /// Texture requests outstanding.
        /// </summary>
        private Dictionary<UUID, List<VObject>> ouststandingRequests = new Dictionary<UUID, List<VObject>>();
        private IrrlichtDevice device = null;
        private SLProtocol m_user = null;
        private static readonly log4net.ILog m_log = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        
        private BlockingQueue<TextureDownloadRequest> downloadTextureQueue = new BlockingQueue<TextureDownloadRequest>();

        private Thread textureFetchThread;
        private TextureExtended defaultTexture;
        private int timeout;

        public virtual void Initialize()
        {
            base.Initialize();
            downloadTextureQueue = new BlockingQueue<TextureDownloadRequest>();
            timeout = Reference.Viewer.Config.Source.Configs["Startup"].GetInt("asset_timeout", 60000); 
            textureFetchThread = new Thread(new ThreadStart(TextureFetchHandler));
            textureFetchThread.Start();

            defaultTexture = new TextureExtended(Reference.VideoDriver.GetTexture(Util.ApplicationDataDirectory + @"\media\textures\dummy_white.tga").Raw, ".tga");
        }

        public virtual void Cleanup()
        {
            if (defaultTexture != null)
            {
                defaultTexture = null;
            }
            if (textureFetchThread != null)
            {
                textureFetchThread.Abort();
                textureFetchThread = null;
            }
            lock (memoryTextures)
            {
                memoryTextures.Clear();
            }
            lock (ouststandingRequests)
            {
                ouststandingRequests.Clear();
            }
            base.Cleanup();
        }

        object TextureFetchJob(object arg)
        {
            IrrManager.IrrWorkItem irrWorkItem = (IrrManager.IrrWorkItem)arg;
            TextureDownloadRequest req = (TextureDownloadRequest)irrWorkItem.arg;

            m_log.Debug("[TextureFetchJob]: handling req " + req.uuid);
            try
            {
                RestClient rest = new RestClient(VUtil.assetServerUri);
                rest.RequestMethod = "GET";
                rest.AddResourcePath("assets");
                rest.AddResourcePath(req.uuid.ToString());
                rest.AddHeader("Authorization", "OpenGrid " + VUtil.authToken.ToString());

                System.IO.Stream stream = rest.Request(timeout);
                m_log.Debug("[TextureFetchJob]: downloaded JP2 for " + req.uuid);

                XmlSerializer xs = new XmlSerializer(typeof(AssetBase));

                //System.IO.StreamReader x = new StreamReader(stream);
                //string test = x.ReadToEnd();

                //stream.Seek(0, SeekOrigin.Begin);
                AssetBase ab = (AssetBase)xs.Deserialize(stream);
                OpenViewer.Primitives.ExtendedAssetTexture texAsset = new OpenViewer.Primitives.ExtendedAssetTexture(req.uuid, ab.Data,ab.Type);
                imageReceivedCallback(texAsset);
                return null;
            }
            catch (Exception e)
            {
                m_log.Warn("[TextureFetchJob]: could not fetch texture " + req.uuid + ": " + e.Message);
                if (e is System.Net.WebException && ((System.Net.WebException)e).Status == System.Net.WebExceptionStatus.ProtocolError)
                {
                    // no retry
                    return null;
                }
                else
                {
                    return irrWorkItem;
                }
            }
        }

        /// <summary>
        /// This loop constantly checks the downloadTextureQueue and processes the items in it
        /// </summary>
         void TextureFetchHandler()
         {
            // Add an initial wait so that prims can download to a satisfactory level before textures clog up the tubes
            // Thread.Sleep(10000);
            while (true)
            {
                // Limit outstanding requests
                // outstandingRequests is not increased when synchronous download is used
                if (downloadQueue.Count > 4)
                {
                    List<UUID> pruneList = new List<UUID>();
                    foreach (KeyValuePair<UUID, long[]> kvp in downloadQueue)
                    {
                        if (kvp.Value[3] < System.DateTime.Now.Ticks - 300000000)
                            pruneList.Add(kvp.Key);
                    }

                    foreach (UUID uuid in pruneList)
                    {
                        downloadQueue.Remove(uuid);
                        m_user.CancelTexture(uuid);
                        TextureDownloadRequest req = new TextureDownloadRequest();
                        req.uuid = uuid;
                        downloadTextureQueue.Enqueue(req);
                        m_log.Debug("[TEXTUREMANAGER]: Pruned request: " + uuid);
                    }
                    Thread.Sleep(500);
                }
                else
                {
                    // Get the next download request and process it
                    TextureDownloadRequest req = null;
                    req = downloadTextureQueue.Dequeue(); // blocking
                    if (req != null)
                    {
                        if (this.texDownloadStyle == TextureDownloadStyle.TEX_DOWNLOAD_LIBOMV)
                        {
                            // Send RequestImage to server
                            if (!downloadQueue.ContainsKey(req.uuid))
                            {
                                downloadQueue.Add(req.uuid, new long[4]);
                                downloadQueue[req.uuid][2] = 1;
                            }
                            downloadQueue[req.uuid][3] = System.DateTime.Now.Ticks;
                            m_user.RequestTexture(req.uuid);
                            m_log.Info("[TEXTURE]: RequestedTexture " + req.uuid);
                        }
                        else
                        {
                            viewer.IrrManager.IrrWorkItemQueue(new IrrManager.IrrWorkItem("TextureFetchJob", new WorkItemCallback(TextureFetchJob), req));
                        }
                    }
                    req = null;
                }
            }
        }

        public TextureManager(Viewer viewer)
            : base(viewer, -1)
        {
            this.viewer = viewer;
            driver = Reference.VideoDriver;
            device = Reference.Device;
            imagefolder = Util.TextureFolder;
            m_user = Reference.Viewer.ProtocolManager.AvatarConnection;
            m_user.OnImageReceived += imageReceivedCallback;

            if (!driver.QueryFeature(VideoDriverFeature.PixelShader_1_1) &&
                !driver.QueryFeature(VideoDriverFeature.ARB_FragmentProgram_1))
            {
                device.Logger.Log("WARNING: Pixel shaders disabled \n" +
                   "because of missing driver/hardware support.");
                shaderYN=false;
            }
            if (!driver.QueryFeature(VideoDriverFeature.VertexShader_1_1) &&
                !driver.QueryFeature(VideoDriverFeature.ARB_FragmentProgram_1))
            {
                device.Logger.Log("WARNING: Vertex shaders disabled \n" +
                   "because of missing driver/hardware support.");
                shaderYN = false;
            }


            if (shaderYN)
            {
                GPUProgrammingServices gpu = driver.GPUProgrammingServices;
                if (gpu != null)
                {
                    OnShaderConstantSetDelegate callBack = OnSetConstants;
                    newMaterialType1 = gpu.AddHighLevelShaderMaterial(GOOCH_VERTEX_GLSL,"main",VertexShaderType._1_1, GOOCH_FRAG_GLSL,"main", PixelShaderType._1_1, callBack, MaterialType.Solid, 0);
                }

            }
        }
        /// <summary>
        /// Requests an image for an object.
        /// </summary>
        /// <param name="assetID"></param>
        /// <param name="requestor"></param>
        public void RequestImage(UUID assetID, VObject requestor)
        {
            
            TextureExtended tex = null;

            lock (memoryTextures)
            {
                
                if (memoryTextures.ContainsKey(assetID))
                {
                    tex = memoryTextures[assetID];
                }
            }

            if (tex != null)
            {
#if DebugTexturePipeline
                m_log.Debug("[3Di Mesh]: Already have texture in memory: " + assetID);
#endif
#if DebugTexturePipeline
                m_log.Debug("RequestImage 1 calling applyTexture");
#endif
                // We already have the texture, jump to applyTexture
                applyTexture(tex, requestor, assetID);

                // Apply the texture to all objects that are already waiting for this texture
                lock (ouststandingRequests)
                {
                    if (ouststandingRequests.ContainsKey(assetID))
                    {
                        m_log.Warn("[TEXTURE]: Applying texture from memory to outstanding requestors.");
                        foreach (VObject vObj in ouststandingRequests[assetID])
                        {
                            applyTexture(tex, vObj, assetID);
                        }
                        ouststandingRequests.Remove(assetID);
                    }
                }

                return;
            }

            // Check to see if we've got the texture on disk

            string texturefolderpath = imagefolder;
            if (File.Exists(System.IO.Path.Combine(texturefolderpath, assetID.ToString() + ".tga")))
            {
                Texture texTnorm = driver.GetTexture(System.IO.Path.Combine(texturefolderpath, assetID.ToString() + ".tga"));
                if (texTnorm != null)
                    tex = new TextureExtended(texTnorm.Raw, ".tga");
                if (tex != null)
                {
#if DebugTexturePipeline
                    m_log.Debug("[3Di Mesh]: Already have texture locally on disk: " + assetID);
#endif
                    lock (memoryTextures)
                    {
                        if (!memoryTextures.ContainsKey(assetID))
                        {
                            // Add it to the texture cache.
                            memoryTextures.Add(assetID, tex);
                        }
                    }

#if DebugTexturePipeline
                    m_log.Debug("RequestImage 2 calling applyTexture");
#endif
                    // apply texture
                    applyTexture(tex, requestor, assetID);

                    // Apply the texture to all objects that are already waiting for this texture
                    lock (ouststandingRequests)
                    {
                        if (ouststandingRequests.ContainsKey(assetID))
                        {
                            m_log.Warn("[TEXTURE]: Applying texture from memory to outstanding requestors.");
                            foreach (VObject vObj in ouststandingRequests[assetID])
                            {
                                applyTexture(tex, vObj, assetID);
                            }
                            ouststandingRequests.Remove(assetID);
                        }
                    }

                    return;
                }

            }

            // Check if we've already got an outstanding request for this texture
            lock (ouststandingRequests)
            {
                if (ouststandingRequests.ContainsKey(assetID))
                {
                    // Add it to the objects to be notified when this texture download is complete.
                    ouststandingRequests[assetID].Add(requestor);
#if YK_ADD_DEFAULT_TEXTURE
                    applyTexture(null, requestor, assetID);
#endif

                    return;
                }
                else 
                {
                    // Create a new outstanding request entry
                    List<VObject> requestors = new List<VObject>();
                    requestors.Add(requestor);
                    ouststandingRequests.Add(assetID,requestors);
                    
                }
            }

#if DebugTexturePipeline
            m_log.Debug("[3Di Mesh]: Requesting from libomv the following texture: " + assetID);
#endif

            if (string.IsNullOrEmpty(m_user.m_user.Network.AssetServerUri))
            {
                this.texDownloadStyle = TextureDownloadStyle.TEX_DOWNLOAD_LIBOMV;
            }

            TextureDownloadRequest req = new TextureDownloadRequest();
            req.uuid = assetID;
            downloadTextureQueue.Enqueue(req); // no need to lock b/c it's a BlockingQueue which needs no synchronization
            m_log.Info("[TEXTURE]: Added to DownloadTextureQueue current count " + downloadTextureQueue.Count);
            /*
            if (this.texDownloadStyle == TextureDownloadStyle.TEX_DOWNLOAD_LIBOMV)
            {
                // Request texture from LibOMV
                m_user.RequestTexture(assetID);
            }
            else
            {
                // request texture directly from assetserver via our own background thread
                TextureDownloadRequest req = new TextureDownloadRequest();
                req.uuid = assetID;
                downloadTextureQueue.Enqueue(req); // no need to lock b/c it's a BlockingQueue which needs no synchronization
            }
            */
        }

        /// <summary>
        /// If we've got the texture, return it and true.  If not, then return false
        /// </summary>
        /// <param name="assetID">the Asset ID of the texture</param>
        /// <param name="tex">The texture</param>
        /// <returns>If we have the texture or not</returns>
        public bool tryGetTexture(UUID assetID, out TextureExtended tex)
        {

            tex = null;
            lock (memoryTextures)
            {
                if (memoryTextures.ContainsKey(assetID))
                {
                    tex = memoryTextures[assetID];
                }
            }

            if (tex != null)
            {
                return true;
            }

            string texturefolderpath = imagefolder;

            // Check if we've got this texture on the file system.
            if (File.Exists(System.IO.Path.Combine(texturefolderpath, assetID.ToString() + ".tga")))
            {
                Texture texTnorm = driver.GetTexture(System.IO.Path.Combine(texturefolderpath, assetID.ToString() + ".tga"));
                tex = new TextureExtended(texTnorm.Raw, ".tga");
                if (tex != null)
                {
                    lock (memoryTextures)
                    {
                        if (!memoryTextures.ContainsKey(assetID))
                        {
                            memoryTextures.Add(assetID, tex);
                        }
                    }
                    return true;
                }

            }

            return false;
        }

        public uint TextureCacheCount
        {
            get { return (uint)memoryTextures.Count; }
        }

        public void ClearMemoryCache()
        {
            lock (memoryTextures)
            {
                foreach (Texture tx in memoryTextures.Values)
                {
                    tx.Dispose();
                }
                memoryTextures.Clear();
            }
                
            m_log.Debug("[TEXTURE]: Memory Cache Cleared");
        }

        /// <summary>
        /// Bread and butter of the texture system.
        /// This is the start point for the texture-> graphics pipeline
        /// </summary>
        /// <param name="tex"></param>
        /// <param name="vObj"></param>
        /// <param name="AssetID"></param>
        public void applyTexture(TextureExtended tex, VObject vObj, UUID AssetID)
        {
            //return;
            try
            {
                // works
                if (vObj.Mesh == null)
                    return;

                // Check if we have a  sculptie and its sculpting texture
                // If yes, don't apply the texture
                if (vObj.Prim.Sculpt != null && vObj.Prim.Sculpt.SculptTexture == AssetID)
                {
                    m_log.Debug("[TEXTURE]: Skipping applyTexture for sculpt " + AssetID);
                    return;
                }

                bool alphaimage = false;

#if YK_ADD_DEFAULT_TEXTURE
                if (tex == null)
                    tex = defaultTexture;
#endif
                // Check if we've already run this through our image alpha checker
                if (tex.Userdata == null)
                {
                    // Check if this image has an alpha channel in use
                    // All textures are 32 Bit and alpha capable, so we have to scan it for an 
                    // alpha pixel
                    Color[,] imgcolors;

                    //tex.Lock();
                    try
                    {
                        imgcolors = tex.Retrieve();
                        //tex.Unlock();
                        for (int i = 0; i < imgcolors.GetUpperBound(0); i++)
                        {
                            for (int j = 0; j < imgcolors.GetUpperBound(1); j++)
                            {
                                if (imgcolors[i, j].A != 255)
                                {
                                    alphaimage = true;
                                    break;
                                }
                            }
                            if (alphaimage)
                                break;
                        }
                    }
                    catch (OutOfMemoryException)
                    {
                        alphaimage = false;
                    }
                    // Save result
                    tex.Userdata = (object)alphaimage;
                }
                else
                {
                    // Use cached result
                    alphaimage = (bool)tex.Userdata;
                }


//#if NOTYET
                if (vObj._3DiIrrfileUUID != UUID.Zero && vObj.IrrData != null)
                {
#if DebugTexturePipeline
                    m_log.Debug("[3Di Mesh]: 3Di mesh applyTexture for tex " + AssetID + " for irrfile " + vObj._3DiIrrfileUUID);
#endif
                    for (int iTex = 0; iTex < vObj.IrrData.Materials.Count; iTex++)
                    {
#if DebugTexturePipeline
                        m_log.Debug("[3Di Mesh]: This mesh references a texture num " + iTex + ": " + vObj.IrrData.Materials[iTex].Texture1);
#endif
                        if (System.IO.Path.GetFileNameWithoutExtension(vObj.IrrData.Materials[iTex].Texture1) == AssetID.ToString())
                        {
#if DebugTexturePipeline
                            m_log.Debug("[3Di Mesh]: Found the texture reference inside the mesh; loading texture and re-assigning the reference.");
#endif
                            Texture loadedTex = device.VideoDriver.GetTexture(AssetID.ToString() + tex.extension);
                            if (vObj.Node.Children.Length > 0)
                            {
                                vObj.Node.Children[0].GetMaterial(iTex).Texture1 = loadedTex;
                            }
                            else
                            {
#if DebugTexturePipeline
                                m_log.Debug("[3Di Mesh]: Could not assign texture; mesh child not found");
#endif
                            }
                        }
                    }
#if DebugTexturePipeline
                    m_log.Debug("[3Di Mesh]: Finished all materials in this mesh.");
#endif
                    if (alphaimage)
                    {
                        vObj.Node.Children[0].SetMaterialType(MaterialType.TransparentAlphaChannel);
                        device.SceneManager.RegisterNodeForRendering(vObj.Node.Children[0], SceneNodeRenderPass.Transparent);
                    }

                }
                else 
//#endif


                // Apply the Texture based on the TextureEntry
                if(vObj.Prim.Textures != null)
                {
                    device.SceneManager.MeshCache.RemoveMesh(vObj.Mesh);
                    // Check the default texture to ensure that it's not null (why would it be null?)
                    if (vObj.Prim.Textures.DefaultTexture != null)
                    {
                        Color4 coldata = vObj.Prim.Textures.DefaultTexture.RGBA;

                        float shinyval = 0;
                        switch (vObj.Prim.Textures.DefaultTexture.Shiny)
                        {
                            case Shininess.Low:
                                shinyval = 0.8f;
                                coldata.R *= 0.8f;
                                coldata.B *= 0.8f;
                                coldata.G *= 0.8f;
                                break;
                            case Shininess.Medium:
                                shinyval = 0.7f;
                                coldata.R *= 0.6f;
                                coldata.B *= 0.6f;
                                coldata.G *= 0.6f;
                                break;
                            case Shininess.High:
                                shinyval = 0.6f;
                                coldata.R *= 0.3f;
                                coldata.B *= 0.3f;
                                coldata.G *= 0.3f;
                                break;
                        }
                        
                        // The mesh buffers correspond to the faces defined in the textureentry

                        int mbcount = vObj.Mesh.MeshBufferCount;
                        for (int j = 0; j < mbcount; j++)
                        {
                            // Only apply default texture if there isn't one already!
                            // we don't want to overwrite a face specific texture with the default
                            if (vObj.Prim.Textures.DefaultTexture.TextureID == AssetID)
                            {
                                ApplyFaceSettings(vObj, alphaimage, vObj.Prim.Textures.DefaultTexture, tex, j, shinyval, coldata);

                            }
                            else
                            {
                                // Apply color settings
                                ApplyFaceSettings(vObj, alphaimage, vObj.Prim.Textures.DefaultTexture, null, j, shinyval, coldata);
                            }


                            vObj.Mesh.GetMeshBuffer(j).Material.NormalizeNormals = true;
                            vObj.Mesh.GetMeshBuffer(j).Material.GouraudShading = true;
                            vObj.Mesh.GetMeshBuffer(j).Material.BackfaceCulling = (this.texDownloadStyle == TextureDownloadStyle.TEX_DOWNLOAD_ASSETSERVER);
                        }

                    }

                    // default taken care of..   now on to the individual face settings.
                    for (int i = 0; i < vObj.Prim.Textures.FaceTextures.Length; i++)
                    {
                        if (vObj.Prim.Textures.FaceTextures[i] != null)
                        {
                            Primitive.TextureEntryFace teface = vObj.Prim.Textures.FaceTextures[i];

                            if (vObj.Mesh.MeshBufferCount > i)
                            {
                                //if (tex.
                                Color4 coldata = teface.RGBA;
                                float shinyval = 0;
                                switch (teface.Shiny)
                                {
                                    case Shininess.Low:
                                        shinyval = 0.8f;
                                        coldata.R *= 0.8f;
                                        coldata.B *= 0.8f;
                                        coldata.G *= 0.8f;
                                        break;
                                    case Shininess.Medium:
                                        shinyval = 0.7f;
                                        coldata.R *= 0.6f;
                                        coldata.B *= 0.6f;
                                        coldata.G *= 0.6f;
                                        break;
                                    case Shininess.High:
                                        shinyval = 0.6f;
                                        coldata.R *= 0.3f;
                                        coldata.B *= 0.3f;
                                        coldata.G *= 0.3f;
                                        break;
                                }

                                // Apply texture only if this face has it linked
                                if (teface.TextureID == AssetID)
                                {
                                    ApplyFaceSettings(vObj, alphaimage, teface, tex, i, shinyval, coldata);
                                }
                                else
                                {
                                    // Only apply the color settings..
                                    ApplyFaceSettings(vObj, alphaimage, teface, null, i, shinyval, coldata);
                                }
                                vObj.Mesh.GetMeshBuffer(i).Material.NormalizeNormals = true;
                                vObj.Mesh.GetMeshBuffer(i).Material.GouraudShading = true;
                                vObj.Mesh.GetMeshBuffer(i).Material.BackfaceCulling = (this.texDownloadStyle == TextureDownloadStyle.TEX_DOWNLOAD_ASSETSERVER);
                            }
                            else
                            {
                                m_log.Warn("[TEXTUREDEF]: Unable to apply Texture to face because mesh buffer doesn't have definition for face");

                            }
                        }// end check if textureentry face is null
                    } // end loop over textureentry faces array

                    if (vObj.Node is MeshSceneNode)
                    {
                        MeshSceneNode msn = (MeshSceneNode)vObj.Node;
                        
                        msn.SetMesh(vObj.Mesh);
                        if (vObj.Prim.Textures != null)
                        {
                            // Check the default texture to ensure that it's not null (why would it be null?)
                            if (vObj.Prim.Textures.DefaultTexture != null)
                            {
                                Color4 coldata = vObj.Prim.Textures.DefaultTexture.RGBA;
                                IrrlichtNETCP.Color objColor = new Color(
                                    Util.Clamp<int>((int)(coldata.A * 255), 0, 255),
                                    Util.Clamp<int>((int)(coldata.R * 255), 0, 255),
                                    Util.Clamp<int>((int)(coldata.G * 255), 0, 255),
                                    Util.Clamp<int>((int)(coldata.B * 255), 0, 255)
                                    );

                                // Set material color.
                                for (int i = 0; i < msn.MaterialCount; i++)
                                {
#if MATERIAL_DEBUG
                                    lock(NativeElement.Elements) {System.Diagnostics.Debug.WriteLine("Element count before get:" + NativeElement.Elements.Count);}
#endif
                                    msn.GetMaterial(i).AmbientColor = objColor;
#if MATERIAL_DEBUG
                                    lock (NativeElement.Elements) { System.Diagnostics.Debug.WriteLine("Element count after get:" + NativeElement.Elements.Count); }
#endif
                                    msn.GetMaterial(i).DiffuseColor = objColor;
                                    msn.GetMaterial(i).SpecularColor = Color.Black;
                                    msn.GetMaterial(i).EmissiveColor = Color.Black;
                                    msn.GetMaterial(i).Shininess = 0;
                                }
                            }
                        }

#if RECALC_BOUNDINGBOX
                        Box3D box = new Box3D(0, 0, 0, 0, 0, 0);
                        for (int i = 0; i < msn.GetMesh().MeshBufferCount; i++)
                        {
                            msn.GetMesh().GetMeshBuffer(i).RecalculateBoundingBox();
                            box.AddInternalBox(msn.GetMesh().GetMeshBuffer(i).BoundingBox);
                        }
                        msn.GetMesh().BoundingBox = box;
#endif
                    }
                    else
                    {
                        // Swap out the visible untextured object with a textured one.
                        // SceneNode sn = device.SceneManager.AddMeshSceneNode(vObj.Mesh, ParentNode, -1);
                        // ZAKI: Change TextureManager Parent to actual parent node
                        SceneNode sn = device.SceneManager.AddMeshSceneNode(vObj.Mesh, vObj.Node.Parent, -1);
                        sn.Position = vObj.Node.Position;
                        sn.Rotation = vObj.Node.Rotation;
                        sn.Scale = vObj.Node.Scale;
                        sn.DebugDataVisible = DebugSceneType.Off;

                        // If it's translucent, register it for the Transparent phase of rendering
                        if (vObj.Prim.Textures.DefaultTexture.RGBA.A != 1)
                        {
                            device.SceneManager.RegisterNodeForRendering(sn, SceneNodeRenderPass.Transparent);
                        }
                        // Add the new triangle selector
                        sn.TriangleSelector = device.SceneManager.CreateTriangleSelector(vObj.Mesh, sn);
                        sn.TriangleSelector.Drop();
                        Reference.Viewer.EntityManager.AddTriangleSelector(sn.TriangleSelector, sn); 

                        // Delete the old node. 
                        SceneNode oldnode = vObj.Node;
                        Reference.Viewer.EntityManager.DeleteNode(oldnode);

                        // Assign new node
                        vObj.Node = sn;

                    }
                } // prim texture is not null


            }
            catch (AccessViolationException)
            {
                VUtil.LogConsole(this.ToString() + "[ACCESSVIOLATION]", " TextureManager::ApplyTexture");
                m_log.Error("[TEXTURE]: Failed to load texture.");
            }
            catch (NullReferenceException)
            {
                m_log.Error("unable to update texture");
            }
        }

        /// <summary>
        /// Applies individual face settings
        /// </summary>
        /// <param name="vObj"></param>
        /// <param name="alpha">Is this an alpha texture</param>
        /// <param name="teface">Texture Entry Face</param>
        /// <param name="tex">Texture to apply</param>
        /// <param name="face">Which face this is</param>
        /// <param name="shinyval">The selected shiny value</param>
        /// <param name="coldata">The modified Color settings</param>
        public void ApplyFaceSettings(VObject vObj, bool alpha, Primitive.TextureEntryFace teface, Texture tex, int face, 
            float shinyval, Color4 coldata)
        {
            // Apply texture
            if (tex != null)
            {
                vObj.Mesh.GetMeshBuffer(face).Material.Texture1 = tex;
            }

            // Apply colors/transforms
            if (teface != null)
            {
                ApplyFace(vObj, alpha, face, teface, shinyval, coldata);
            }
        }

        public void ApplyFace(VObject vObj, bool alpha, int face, Primitive.TextureEntryFace teface, float shinyval, Color4 coldata)
        {
            ModifyMeshBuffer(coldata, shinyval, face, vObj.Mesh, teface, alpha);
        }

        public void ModifyMeshBuffer(Color4 coldata, float shinyval, int j, Mesh mesh, Primitive.TextureEntryFace teface, bool alpha)
        {
            MeshBuffer mb = mesh.GetMeshBuffer(j);

            // If it's an alpha texture, ensure Irrlicht knows or you get artifacts.
            if (alpha)
            {
                mb.Material.MaterialType = MaterialType.TransparentAlphaChannel;
            }

            // Create texture transform based on the UV transforms specified in the texture entry
            IrrlichtNETCP.Matrix4 mat = mb.Material.Layer1.TextureMatrix;

            mat = IrrlichtNETCP.Matrix4.buildTextureTransform(teface.Rotation, new Vector2D(-0.5f, -0.5f * teface.RepeatV), new Vector2D(0.5f + teface.OffsetU, -(0.5f + teface.OffsetV)), new Vector2D(teface.RepeatU, teface.RepeatV));
            mb.Material.Layer1.TextureMatrix = mat;
            
            mb.Material.ZWriteEnable = true;
            mb.Material.BackfaceCulling = (this.texDownloadStyle == TextureDownloadStyle.TEX_DOWNLOAD_ASSETSERVER);
            
            if (coldata.A != 1)
            {
                coldata.R *= coldata.A;
                coldata.B *= coldata.A;
                coldata.G *= coldata.A;
            }

            mb.SetColor(new Color(
                Util.Clamp<int>((int)(coldata.A * 255), 0, 255),
                Util.Clamp<int>((int)(coldata.R * 255), 0, 255),
                Util.Clamp<int>((int)(coldata.G * 255), 0, 255),
                Util.Clamp<int>((int)(coldata.B * 255), 0, 255)
                ));

            // If it's partially translucent inform Irrlicht
            if (coldata.A != 1)
            {
                mb.Material.MaterialType = MaterialType.TransparentVertexAlpha;
                mb.Material.Lighting = false;
            }
            else
            {
                mb.Material.Lighting = !teface.Fullbright;

                if (shinyval > 0)
                {
                    
                    mb.Material.MaterialType = (MaterialType)newMaterialType1;
                    mb.Material.Lighting = false;
                }
            }
        }

        // LibOMV callback for completed image texture.
        public void imageReceivedCallback(AssetTexture asset)
        {      
            if (asset == null)
            {
                m_log.Debug("[TEXTURE]: GotLIBOMV callback but asset was null");
                lock (ouststandingRequests)
                {
                }
                return;
            }
            m_log.Debug("[TEXTURE]: GotLIBOMV callback for asset" + asset.AssetID);
            lock (downloadQueue)
            {
                if (downloadQueue.ContainsKey(asset.AssetID))
                    downloadQueue.Remove(asset.AssetID);
            }
            bool result = false;
            bool bNonJp2000 = true;
            string strExtension = ".tga";
            try
            {
                if (asset is AssetTexture)
                {
                    bNonJp2000 = false;
                    result = asset.Decode();
                }
                else
                {
                    //Paupaw:Get the AssetType
                    switch (((OpenViewer.Primitives.ExtendedAssetTexture)asset).ExtAssetType)
                    {
                        case (int)AssetType.ImageJPEG:
                            result = true;
                            strExtension = ".jpg";
                            break;
                        case (int)AssetType.ImageTGA:
                            result = true;
                            strExtension = ".tga";
                            break;
                        case (int)AssetType.Texture: //JP2000
                            bNonJp2000 = false;
                            result = asset.Decode();
                            break;
                    }
                }
            }
            catch (Exception)
            {
                m_log.Debug("[TEXTURE]: Failed to decode asset " + asset.AssetID);
            }
            if (result)
            { 
                
                // Write it to disk for picking up later in the pipeline.
                string texturefolderpath = imagefolder;

                string texturepath = System.IO.Path.Combine(texturefolderpath,asset.AssetID.ToString() + strExtension);
                byte[] imgdata = null;
                if (bNonJp2000)
                {
                    imgdata = asset.AssetData;
                }
                else
                {
                    imgdata = asset.Image.ExportTGA();
                }
                    
                FileStream fi = (File.Open(texturepath, FileMode.Create));
                BinaryWriter bw = new BinaryWriter(fi);
                bw.Write(imgdata);
                bw.Flush();
                bw.Close();
                
                // Update nodes that the texture is downloaded.
                List<VObject> nodesToUpdate = new List<VObject>();
                lock (ouststandingRequests)
                {
                    if (ouststandingRequests.ContainsKey(asset.AssetID))
                    {
                        nodesToUpdate = ouststandingRequests[asset.AssetID];
                        ouststandingRequests.Remove(asset.AssetID);
                    }
                }
                lock (nodesToUpdate)
                {
                    for (int i = 0; i < nodesToUpdate.Count; i++)
                    {
                        VObject vObj = nodesToUpdate[i];

                        if (vObj != null)
                        {
                            if (OnTextureLoaded != null)
                            {
                                OnTextureLoaded(asset.AssetID.ToString(), strExtension, vObj, asset.AssetID);
                            }
                            
                        }
                        
                    }
                }
            }
        }
        public void OnSetConstants(MaterialRendererServices services, int userData)
        {
            //This is called when we need to set shader's constants
            //It is very simple and taken from Irrlicht's original shader example.
            //Please notice that many types already has a "ToShader" func made especially
            //For exporting to shader floats !
            //If the structure you want has no such function, then simply use "ToUnmanaged" instead
            //IrrlichtNETCP.Matrix4 world = driver.GetTransform(TransformationState.World);
            //IrrlichtNETCP.Matrix4 invWorld = world;
            //invWorld.MakeInverse();
            //services.VideoDriver.GPUProgrammingServices.
            //services.SetVertexShaderConstant(invWorld.ToShader(), 0, 4);
            //services.SetVertexShaderConstant("LightPosition", (new Vector3D(128,128,128).ToShader()));

            //IrrlichtNETCP.Matrix4 worldviewproj;
            //worldviewproj = driver.GetTransform(TransformationState.Projection);
            ///worldviewproj *= driver.GetTransform(TransformationState.View);
            //worldviewproj *= world;

            //services.SetVertexShaderConstant(worldviewproj.ToShader(), 4, 4);

            //services.SetVertexShaderConstant(device.SceneManager.ActiveCamera.Position.ToShader(), 8, 1);

            //services.SetVertexShaderConstant(Colorf.Blue.ToShader(), 9, 1);
            //services.SetVertexShaderConstant(Colorf.Blue.ToShader(),9,1);//SurfaceColor; // (0.75, 0.75, 0.75)

            //world = world.GetTransposed();
            //services.SetVertexShaderConstant(world.ToShader(), 10, 4);
        }

        // Gooch shader based on the Gooch shader by Randi Rost for 3Dlabs Inc LTD.  (standard MIT licence)
        static string GOOCH_VERTEX_GLSL =
@"
uniform vec3  LightPosition;  // not used yet..    but will be for the sun

varying float NdotL;
varying vec3  ReflectVec;
varying vec3  ViewVec;

void main(void)
{
    vec3 ecPos      = vec3 (gl_ModelViewMatrix * gl_Vertex);
    vec3 tnorm      = normalize(gl_NormalMatrix * gl_Normal);
    vec3 lightVec   = normalize(gl_LightSource[0].position.xyz - ecPos);
    ReflectVec      = normalize(reflect(-lightVec, tnorm));
    ViewVec         = normalize(-ecPos);
    NdotL           = (dot(lightVec, tnorm) + 1.0) * 0.5;
    gl_Position     = ftransform();
    gl_TexCoord[0] = gl_MultiTexCoord0;
}	
	

";
        static string GOOCH_FRAG_GLSL =
@"
varying float NdotL;
varying vec3  ReflectVec;
varying vec3  ViewVec;
uniform sampler2D colorMap;

void main (void)
{
	
    vec3 kfinal   = mix(vec3(texture2D(colorMap, gl_TexCoord[0].xy).rgb), gl_Color, 0.5);

    vec3 nreflect = normalize(ReflectVec);
    vec3 nview    = normalize(ViewVec);

    float spec    = max(dot(nreflect, nview), 0.0);
    spec          = pow(spec, 4.0);
   
    gl_FragColor = vec4 (min(kfinal + spec, 1.0), 1.0);
}
";
}
}
