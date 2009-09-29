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
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Microsoft.Win32;
using OpenViewerAX;

namespace OpenViewerUnreg
{
    class OpenViewerUnreg
    {
        static void Main(string[] args)
        {
            string guid = null;

            foreach (object o in typeof(OpenViewerCtl).GetCustomAttributes(false))
            {
                if (o is GuidAttribute)
                {
                    GuidAttribute guidattr = (GuidAttribute)o;
                    guid = guidattr.Value;
                }
            }
            if (guid == null)
                System.Environment.Exit(1);

            try { Registry.ClassesRoot.DeleteSubKeyTree("CLSID\\{" + guid + "}"); }
            catch {}
            try { Registry.ClassesRoot.DeleteSubKeyTree("OpenViewerAX.ActiveControl"); }
            catch {}
            try { Registry.CurrentUser.DeleteSubKeyTree("Software\\Microsoft\\Windows\\CurrentVersion\\Ext\\Stats\\{" + guid + "}"); }
            catch {}
            try { Registry.LocalMachine.DeleteSubKeyTree("SOFTWARE\\Classes\\CLSID\\{" + guid + "}"); }
            catch {}
            try { Registry.LocalMachine.DeleteSubKeyTree("SOFTWARE\\Microsoft\\Code Store Database\\Distribution Units\\{" + guid + "}"); }
            catch {}

            RegistryKey subkey = Registry.LocalMachine.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\ModuleUsage",true);
            foreach (string _name in subkey.GetSubKeyNames())
            {
                string name = _name.Replace("/", "\\");
                if (!String.IsNullOrEmpty(Path.GetFileName(name)) && String.Compare(Path.GetFileName(name),"3Di_OpenViewer_Setup.exe") == 0)
                    subkey.DeleteSubKeyTree(_name);
            }

            foreach (object o in typeof(IJavaScriptApiEvent).GetCustomAttributes(false))
            {
                if (o is GuidAttribute)
                {
                    GuidAttribute guidattr = (GuidAttribute)o;
                    try { Registry.ClassesRoot.DeleteSubKeyTree("Interface\\{" + guidattr.Value + "}"); }
                    catch {}
                    try { Registry.LocalMachine.DeleteSubKeyTree("SOFTWARE\\Classes\\Interface\\{" + guidattr.Value + "}"); }
                    catch {}
                }
            }
            System.Environment.Exit(0);
        }
    }
}