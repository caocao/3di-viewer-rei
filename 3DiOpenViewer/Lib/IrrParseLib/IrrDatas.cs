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
 */

using System;
using System.Collections.Generic;
using System.Xml;

namespace IrrParseLib
{
    public class IrrDatas
    {
        public IrrMesh Mesh = new IrrMesh();
        public List<IrrMaterial> Materials = new List<IrrMaterial>();
        public List<IrrDatas> Childs = new List<IrrDatas>();
        public IrrAnimationKeys AnimationKey = new IrrAnimationKeys();

        public IrrDatas(XmlTextReader reader, bool isDumpDirectory)
        {
            while (reader.Read())
            {
                // end node.
                if (reader.Name == "node" && (reader.NodeType == XmlNodeType.EndElement))
                {
                    break;
                }

                // attributes (mesh).
                else if (reader.Name == "attributes")
                {
                    Mesh.Load(reader, isDumpDirectory);
                }

                // materials.
                else if (reader.Name == "materials")
                {
                    string dumpDirectory = string.Empty;

                    if (Mesh != null)
                        dumpDirectory = Mesh.DumpDirectory;

                    IrrMaterialParse(reader, dumpDirectory);
                }

                // child.
                else if (reader.Name == "node")
                {
                    Childs.Add(new IrrDatas(reader, isDumpDirectory));
                }
            }
        }

        private void IrrMaterialParse(XmlTextReader reader, string dumpDirectory)
        {
            while (reader.Read())
            {
                if (reader.Name == "materials" && (reader.NodeType == XmlNodeType.EndElement))
                {
                    break;
                }

                else if (reader.Name == "attributes")
                {
                    Materials.Add(new IrrMaterial(reader, dumpDirectory));
                }
            }
        }

        /// <summary>
        /// Read animatmion data from now working directory by Name property.
        /// </summary>
        /// <returns>If succeeded to read animation data, return true</returns>
        public bool CreateAnimationKey()
        {
            return CreateAnimationKey(string.Empty);
        }

        /// <summary>
        /// Read animatmion data from target working directory by Name property.
        /// </summary>
        /// <returns>If succeeded to read animation data, return true</returns>
        public bool CreateAnimationKey(string workDirectory)
        {
            bool flag = false;

            string readPath = workDirectory + Name + ".xml";
            if (System.IO.File.Exists(readPath))
            {
                using (System.IO.StreamReader stream = new System.IO.StreamReader(readPath))
                {
                    using (XmlTextReader reader = new XmlTextReader(stream))
                    {
                        CreateAnimationKey(reader);

                        reader.Close();
                        flag = true;
                    }
                }
            }

            return flag;
        }

        public void CreateAnimationKey(XmlTextReader reader)
        {
            while (reader.Read())
            {
                if (reader.Name == "node" && (reader.NodeType == XmlNodeType.EndElement))
                {
                    break;
                }
                else if (reader.Name == "attributes")
                {
                    if (reader.AttributeCount > 0)
                    {
                        if (reader.GetAttribute("name") == "Name")
                        {
                            AnimationKey.Load(reader);
                            break;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Model name property.
        /// </summary>
        public string Name
        {
            get
            {
                string name = string.Empty;

                if (Mesh.Param.Name != string.Empty)
                {
                    name = Mesh.Param.Name;
                }

                return name;
            }
        }
    }
}