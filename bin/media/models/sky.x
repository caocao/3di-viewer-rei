xof 0303txt 0032
template ColorRGBA {
 <35ff44e0-6c7c-11cf-8f52-0040333594a3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <d3e16e81-7835-11cf-8f52-0040333594a3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template Material {
 <3d82ab4d-62da-11cf-ab39-0020af71e433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template TextureFilename {
 <a42790e1-7810-11cf-8f52-0040333594a3>
 STRING filename;
}

template Frame {
 <3d82ab46-62da-11cf-ab39-0020af71e433>
 [...]
}

template Matrix4x4 {
 <f6f23f45-7686-11cf-8f52-0040333594a3>
 array FLOAT matrix[16];
}

template FrameTransformMatrix {
 <f6f23f41-7686-11cf-8f52-0040333594a3>
 Matrix4x4 frameMatrix;
}

template Vector {
 <3d82ab5e-62da-11cf-ab39-0020af71e433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template MeshFace {
 <3d82ab5f-62da-11cf-ab39-0020af71e433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template Mesh {
 <3d82ab44-62da-11cf-ab39-0020af71e433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

template MeshNormals {
 <f6f23f43-7686-11cf-8f52-0040333594a3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template MeshMaterialList {
 <f6f23f42-7686-11cf-8f52-0040333594a3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material <3d82ab4d-62da-11cf-ab39-0020af71e433>]
}

template Coords2d {
 <f6f23f44-7686-11cf-8f52-0040333594a3>
 FLOAT u;
 FLOAT v;
}

template MeshTextureCoords {
 <f6f23f40-7686-11cf-8f52-0040333594a3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}


Material PDX01_-_Default {
 1.000000;1.000000;1.000000;1.000000;;
 0.000000;
 0.000000;0.000000;0.000000;;
 0.000000;0.000000;0.000000;;

 TextureFilename {
  "sky.jpg";
 }
}

Material PDX08_-_Default {
 1.000000;1.000000;1.000000;1.000000;;
 3.200000;
 0.000000;0.000000;0.000000;;
 0.000000;0.000000;0.000000;;

 TextureFilename {
  "Cloud.tga";
 }
}

Frame GeoSphere01 {
 

 FrameTransformMatrix {
  0.000000,0.000000,1.000000,0.000000,0.000000,0.554198,0.000000,0.000000,-1.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,1.000000;;
 }

 Mesh  {
  196;
  0.000000;10000.0000;0.000000;,
  5257.3110;8506.5078;0.000000;,
  1624.59827;8506.5078;5000.0000;,
  -4253.25439;8506.5078;3090.16919;,
  -4253.25342;8506.5078;-3090.17041;,
  1624.59900;8506.5078;-5000.0000;,
  8944.2714;4472.1357;0.000000;,
  2763.93164;4472.1357;8506.5078;,
  -7236.0683;4472.1357;5257.3100;,
  -7236.0673;4472.1357;-5257.3120;,
  2763.93311;4472.1357;-8506.5078;,
  6881.9091;5257.3110;5000.0000;,
  -2628.65649;5257.3115;8090.1694;,
  -8506.5078;5257.3110;-0.001092;,
  -2628.65454;5257.3110;-8090.1704;,
  6881.9096;5257.3110;-5000.0000;,
  9510.5654;0.000000;3090.16992;,
  5877.8525;0.000000;8090.1699;,
  -0.000437;0.000000;10000.0000;,
  -5877.8520;0.000000;8090.1699;,
  -9510.5664;0.000000;3090.16797;,
  -9510.5654;0.000000;-3090.16968;,
  -5877.8505;0.000000;-8090.1713;,
  0.000119;0.000000;-10000.0000;,
  5877.8549;0.000000;-8090.1684;,
  9510.5664;0.000000;-3090.16504;,
  1834.79407;9830.2353;0.000000;,
  3607.29126;9326.7060;0.000000;,
  566.98242;9830.2353;1744.99292;,
  1114.71423;9326.7060;3430.73804;,
  -1484.37976;9830.2353;1078.46460;,
  -2918.36035;9326.7060;2120.31226;,
  -1484.37939;9830.2353;-1078.46509;,
  -2918.35986;9326.7060;-2120.31299;,
  566.98273;9830.2353;-1744.99292;,
  1114.71472;9326.7060;-3430.73804;,
  4212.61670;8895.2734;1768.60254;,
  2983.81079;8895.2734;3459.90845;,
  -380.270996;8895.2734;4552.9648;,
  -2368.52075;8895.2734;3906.94336;,
  -4447.6372;8895.2744;1045.28406;,
  -4447.6367;8895.2744;-1045.28528;,
  -2368.51953;8895.2744;-3906.94385;,
  -380.270203;8895.2744;-4552.9648;,
  2983.81152;8895.2744;-3459.90845;,
  4212.61719;8895.2744;-1768.60254;,
  6728.8295;7397.4892;0.000000;,
  7971.8842;6037.3041;0.000000;,
  2079.32227;7397.4892;6399.4970;,
  2463.44751;6037.3041;7581.7133;,
  -5443.7377;7397.4892;3955.10620;,
  -6449.3911;6037.3041;4685.7553;,
  -5443.7368;7397.4892;-3955.10742;,
  -6449.3896;6037.3041;-4685.7573;,
  2079.32349;7397.4892;-6399.4970;,
  2463.44873;6037.3041;-7581.7133;,
  6072.2353;7745.9667;1768.60254;,
  6621.7739;6646.8891;3459.90845;,
  194.382538;7745.9667;6321.5673;,
  -1244.32837;6646.8891;7366.8515;,
  -5952.1000;7745.9663;2138.34009;,
  -7390.8105;6646.8891;1093.05542;,
  -3872.98242;7745.9663;-5000.0004;,
  -3323.44360;6646.8891;-6691.3066;,
  3558.46533;7745.9663;-5228.5112;,
  5336.8095;6646.8891;-5228.5112;,
  6072.2358;7745.9667;-1768.60254;,
  6621.7739;6646.8891;-3459.90845;,
  3558.46436;7745.9667;5228.5112;,
  5336.8090;6646.8891;5228.5112;,
  -3872.98364;7745.9663;4999.9990;,
  -3323.44531;6646.8891;6691.3051;,
  -5952.0996;7745.9663;-2138.34180;,
  -7390.8105;6646.8891;-1093.05725;,
  194.383682;7745.9667;-6321.5678;,
  -1244.32690;6646.8891;-7366.8525;,
  8538.8662;4903.3393;1744.99292;,
  7843.5439;5168.0605;3430.73804;,
  979.06781;4903.3393;8660.1777;,
  -839.03815;5168.0610;8519.8095;,
  -7933.7700;4903.3393;3607.29028;,
  -8362.0976;5168.0605;1834.79297;,
  -5882.4067;4903.3393;-6430.7500;,
  -4329.0224;5168.0605;-7385.8452;,
  4298.2431;4903.3398;-7581.7138;,
  5686.6152;5168.0610;-6399.4975;,
  7843.5449;5168.0605;-3430.73853;,
  8538.8681;4903.3398;-1744.99304;,
  5686.6137;5168.0605;6399.4970;,
  4298.2412;4903.3393;7581.7128;,
  -4329.0239;5168.0610;7385.8442;,
  -5882.4082;4903.3393;6430.7485;,
  -8362.0966;5168.0605;-1834.79504;,
  -7933.7695;4903.3393;-3607.29272;,
  -839.03638;5168.0605;-8519.8105;,
  979.06946;4903.3393;-8660.1777;,
  9456.2646;3068.54541;1078.46497;,
  9647.1904;1560.76904;2120.31274;,
  8126.2377;3637.96289;4552.9648;,
  9015.4091;1859.61865;3906.94385;,
  6841.2719;3637.96289;6321.5678;,
  6501.6386;1859.61865;7366.8525;,
  3947.82739;3068.54541;8660.1777;,
  4997.6831;1560.76904;8519.8095;,
  1896.46497;3068.54541;9326.7060;,
  964.60791;1560.76904;9830.2353;,
  -1818.98230;3637.96338;9135.4541;,
  -929.81000;1859.61890;9781.4765;,
  -3898.09888;3637.96338;8459.9082;,
  -4997.1752;1859.61890;8459.9091;,
  -7016.3725;3068.54517;6430.7485;,
  -6558.4511;1560.76904;7385.8442;,
  -8284.1855;3068.54541;4685.7548;,
  -9051.0292;1560.76904;3955.10522;,
  -9250.4296;3637.96313;1093.05505;,
  -9590.0644;1859.61865;2138.33936;,
  -9250.4296;3637.96289;-1093.05701;,
  -9590.0634;1859.61865;-2138.34131;,
  -8284.1835;3068.54517;-4685.7568;,
  -9051.0292;1560.76904;-3955.10669;,
  -7016.3715;3068.54517;-6430.7504;,
  -6558.4501;1560.76904;-7385.8461;,
  -3898.09692;3637.96313;-8459.9091;,
  -4997.1738;1859.61865;-8459.9091;,
  -1818.98071;3637.96313;-9135.4541;,
  -929.80878;1859.61865;-9781.4755;,
  1896.46606;3068.54517;-9326.7060;,
  964.60876;1560.76904;-9830.2353;,
  3947.82886;3068.54517;-8660.1777;,
  4997.6845;1560.76904;-8519.8095;,
  6841.2734;3637.96313;-6321.5668;,
  6501.6411;1859.61865;-7366.8510;,
  8126.2382;3637.96289;-4552.9633;,
  9015.4101;1859.61865;-3906.93994;,
  9456.2646;3068.54541;-1078.46313;,
  9647.1904;1560.76892;-2120.30933;,
  8660.2539;0.000000;5000.0000;,
  7431.4487;0.000000;6691.3061;,
  4067.36646;0.000000;9135.4550;,
  2079.11670;0.000000;9781.4755;,
  -2079.11694;0.000000;9781.4755;,
  -4067.36621;0.000000;9135.4550;,
  -7431.4482;0.000000;6691.3056;,
  -8660.2548;0.000000;4999.9985;,
  -9945.2197;0.000000;1045.28345;,
  -9945.2197;0.000000;-1045.28516;,
  -8660.2548;0.000000;-5000.0009;,
  -7431.4477;0.000000;-6691.3076;,
  -4067.36523;0.000000;-9135.4560;,
  -2079.11621;0.000000;-9781.4765;,
  2079.11792;0.000000;-9781.4755;,
  4067.36816;0.000000;-9135.4531;,
  7431.4511;0.000000;-6691.3032;,
  8660.2558;0.000000;-4999.9960;,
  9945.2197;0.000000;-1045.28137;,
  9945.2187;0.000000;1045.28650;,
  2415.93408;9543.7021;1755.27893;,
  -922.80493;9543.7021;2840.10059;,
  -2986.25879;9543.7021;-0.000368;,
  -922.80432;9543.7021;-2840.10107;,
  2415.93433;9543.7021;-1755.27893;,
  4929.3662;7929.3735;3581.39453;,
  -1882.85095;7929.3735;5794.8178;,
  -6093.0312;7929.3720;-0.000877;,
  -1882.84985;7929.3735;-5794.8188;,
  4929.3666;7929.3735;-3581.39453;,
  7429.5683;6457.4677;-1761.42444;,
  7429.5678;6457.4672;1761.42419;,
  3971.07666;6457.4677;6521.6303;,
  620.64825;6457.4677;7610.2495;,
  -4975.3085;6457.4677;5792.0126;,
  -7045.9858;6457.4672;2941.96729;,
  -7045.9858;6457.4677;-2941.96948;,
  -4975.3066;6457.4672;-5792.0136;,
  620.64966;6457.4677;-7610.2504;,
  3971.07739;6457.4672;-6521.6293;,
  8951.1757;3414.25439;2866.93677;,
  5492.6835;3414.25439;7627.1420;,
  39.446136;3414.25488;9399.0058;,
  -5556.5097;3414.25415;7580.7685;,
  -8926.7968;3414.25439;2941.96704;,
  -8926.7958;3414.25391;-2941.96899;,
  -5556.5087;3414.25391;-7580.7700;,
  39.447456;3414.25439;-9399.0058;,
  5492.6850;3414.25391;-7627.1411;,
  8951.1757;3414.25391;-2866.93481;,
  9871.6425;1597.08191;0.001767;,
  7942.2275;1903.65015;5770.3666;,
  3050.50513;1597.08215;9388.4902;,
  -3033.66113;1903.65027;9336.6494;,
  -7986.3256;1597.08191;5802.4047;,
  -9817.1347;1903.65015;-0.001023;,
  -7986.3261;1597.08215;-5802.4072;,
  -3033.65991;1903.65015;-9336.6494;,
  3050.50635;1597.08203;-9388.4892;,
  7942.2309;1903.65039;-5770.3642;;
  360;
  3;0,28,26;,
  3;26,156,27;,
  3;26,28,156;,
  3;28,29,156;,
  3;27,36,1;,
  3;27,156,36;,
  3;156,37,36;,
  3;156,29,37;,
  3;29,2,37;,
  3;0,30,28;,
  3;28,157,29;,
  3;28,30,157;,
  3;30,31,157;,
  3;29,38,2;,
  3;29,157,38;,
  3;157,39,38;,
  3;157,31,39;,
  3;31,3,39;,
  3;0,32,30;,
  3;30,158,31;,
  3;30,32,158;,
  3;32,33,158;,
  3;31,40,3;,
  3;31,158,40;,
  3;158,41,40;,
  3;158,33,41;,
  3;33,4,41;,
  3;0,34,32;,
  3;32,159,33;,
  3;32,34,159;,
  3;34,35,159;,
  3;33,42,4;,
  3;33,159,42;,
  3;159,43,42;,
  3;159,35,43;,
  3;35,5,43;,
  3;0,26,34;,
  3;34,160,35;,
  3;34,26,160;,
  3;26,27,160;,
  3;35,44,5;,
  3;35,160,44;,
  3;160,45,44;,
  3;160,27,45;,
  3;27,1,45;,
  3;11,57,69;,
  3;69,161,68;,
  3;69,57,161;,
  3;57,56,161;,
  3;68,37,2;,
  3;68,161,37;,
  3;161,36,37;,
  3;161,56,36;,
  3;56,1,36;,
  3;12,59,71;,
  3;71,162,70;,
  3;71,59,162;,
  3;59,58,162;,
  3;70,39,3;,
  3;70,162,39;,
  3;162,38,39;,
  3;162,58,38;,
  3;58,2,38;,
  3;13,61,73;,
  3;73,163,72;,
  3;73,61,163;,
  3;61,60,163;,
  3;72,41,4;,
  3;72,163,41;,
  3;163,40,41;,
  3;163,60,40;,
  3;60,3,40;,
  3;14,63,75;,
  3;75,164,74;,
  3;75,63,164;,
  3;63,62,164;,
  3;74,43,5;,
  3;74,164,43;,
  3;164,42,43;,
  3;164,62,42;,
  3;62,4,42;,
  3;15,65,67;,
  3;67,165,66;,
  3;67,65,165;,
  3;65,64,165;,
  3;66,45,1;,
  3;66,165,45;,
  3;165,44,45;,
  3;165,64,44;,
  3;64,5,44;,
  3;1,46,66;,
  3;66,166,67;,
  3;66,46,166;,
  3;46,47,166;,
  3;67,86,15;,
  3;67,166,86;,
  3;166,87,86;,
  3;166,47,87;,
  3;47,6,87;,
  3;1,56,46;,
  3;46,167,47;,
  3;46,56,167;,
  3;56,57,167;,
  3;47,76,6;,
  3;47,167,76;,
  3;167,77,76;,
  3;167,57,77;,
  3;57,11,77;,
  3;2,48,68;,
  3;68,168,69;,
  3;68,48,168;,
  3;48,49,168;,
  3;69,88,11;,
  3;69,168,88;,
  3;168,89,88;,
  3;168,49,89;,
  3;49,7,89;,
  3;2,58,48;,
  3;48,169,49;,
  3;48,58,169;,
  3;58,59,169;,
  3;49,78,7;,
  3;49,169,78;,
  3;169,79,78;,
  3;169,59,79;,
  3;59,12,79;,
  3;3,50,70;,
  3;70,170,71;,
  3;70,50,170;,
  3;50,51,170;,
  3;71,90,12;,
  3;71,170,90;,
  3;170,91,90;,
  3;170,51,91;,
  3;51,8,91;,
  3;3,60,50;,
  3;50,171,51;,
  3;50,60,171;,
  3;60,61,171;,
  3;51,80,8;,
  3;51,171,80;,
  3;171,81,80;,
  3;171,61,81;,
  3;61,13,81;,
  3;4,52,72;,
  3;72,172,73;,
  3;72,52,172;,
  3;52,53,172;,
  3;73,92,13;,
  3;73,172,92;,
  3;172,93,92;,
  3;172,53,93;,
  3;53,9,93;,
  3;4,62,52;,
  3;52,173,53;,
  3;52,62,173;,
  3;62,63,173;,
  3;53,82,9;,
  3;53,173,82;,
  3;173,83,82;,
  3;173,63,83;,
  3;63,14,83;,
  3;5,54,74;,
  3;74,174,75;,
  3;74,54,174;,
  3;54,55,174;,
  3;75,94,14;,
  3;75,174,94;,
  3;174,95,94;,
  3;174,55,95;,
  3;55,10,95;,
  3;5,64,54;,
  3;54,175,55;,
  3;54,64,175;,
  3;64,65,175;,
  3;55,84,10;,
  3;55,175,84;,
  3;175,85,84;,
  3;175,65,85;,
  3;65,15,85;,
  3;16,97,99;,
  3;99,176,98;,
  3;99,97,176;,
  3;97,96,176;,
  3;98,77,11;,
  3;98,176,77;,
  3;176,76,77;,
  3;176,96,76;,
  3;96,6,76;,
  3;17,101,103;,
  3;103,177,102;,
  3;103,101,177;,
  3;101,100,177;,
  3;102,89,7;,
  3;102,177,89;,
  3;177,88,89;,
  3;177,100,88;,
  3;100,11,88;,
  3;18,105,107;,
  3;107,178,106;,
  3;107,105,178;,
  3;105,104,178;,
  3;106,79,12;,
  3;106,178,79;,
  3;178,78,79;,
  3;178,104,78;,
  3;104,7,78;,
  3;19,109,111;,
  3;111,179,110;,
  3;111,109,179;,
  3;109,108,179;,
  3;110,91,8;,
  3;110,179,91;,
  3;179,90,91;,
  3;179,108,90;,
  3;108,12,90;,
  3;20,113,115;,
  3;115,180,114;,
  3;115,113,180;,
  3;113,112,180;,
  3;114,81,13;,
  3;114,180,81;,
  3;180,80,81;,
  3;180,112,80;,
  3;112,8,80;,
  3;21,117,119;,
  3;119,181,118;,
  3;119,117,181;,
  3;117,116,181;,
  3;118,93,9;,
  3;118,181,93;,
  3;181,92,93;,
  3;181,116,92;,
  3;116,13,92;,
  3;22,121,123;,
  3;123,182,122;,
  3;123,121,182;,
  3;121,120,182;,
  3;122,83,14;,
  3;122,182,83;,
  3;182,82,83;,
  3;182,120,82;,
  3;120,9,82;,
  3;23,125,127;,
  3;127,183,126;,
  3;127,125,183;,
  3;125,124,183;,
  3;126,95,10;,
  3;126,183,95;,
  3;183,94,95;,
  3;183,124,94;,
  3;124,14,94;,
  3;24,129,131;,
  3;131,184,130;,
  3;131,129,184;,
  3;129,128,184;,
  3;130,85,15;,
  3;130,184,85;,
  3;184,84,85;,
  3;184,128,84;,
  3;128,10,84;,
  3;25,133,135;,
  3;135,185,134;,
  3;135,133,185;,
  3;133,132,185;,
  3;134,87,6;,
  3;134,185,87;,
  3;185,86,87;,
  3;185,132,86;,
  3;132,15,86;,
  3;6,96,134;,
  3;134,186,135;,
  3;134,96,186;,
  3;96,97,186;,
  3;135,154,25;,
  3;135,186,154;,
  3;186,155,154;,
  3;186,97,155;,
  3;97,16,155;,
  3;11,100,98;,
  3;98,187,99;,
  3;98,100,187;,
  3;100,101,187;,
  3;99,136,16;,
  3;99,187,136;,
  3;187,137,136;,
  3;187,101,137;,
  3;101,17,137;,
  3;7,104,102;,
  3;102,188,103;,
  3;102,104,188;,
  3;104,105,188;,
  3;103,138,17;,
  3;103,188,138;,
  3;188,139,138;,
  3;188,105,139;,
  3;105,18,139;,
  3;12,108,106;,
  3;106,189,107;,
  3;106,108,189;,
  3;108,109,189;,
  3;107,140,18;,
  3;107,189,140;,
  3;189,141,140;,
  3;189,109,141;,
  3;109,19,141;,
  3;8,112,110;,
  3;110,190,111;,
  3;110,112,190;,
  3;112,113,190;,
  3;111,142,19;,
  3;111,190,142;,
  3;190,143,142;,
  3;190,113,143;,
  3;113,20,143;,
  3;13,116,114;,
  3;114,191,115;,
  3;114,116,191;,
  3;116,117,191;,
  3;115,144,20;,
  3;115,191,144;,
  3;191,145,144;,
  3;191,117,145;,
  3;117,21,145;,
  3;9,120,118;,
  3;118,192,119;,
  3;118,120,192;,
  3;120,121,192;,
  3;119,146,21;,
  3;119,192,146;,
  3;192,147,146;,
  3;192,121,147;,
  3;121,22,147;,
  3;14,124,122;,
  3;122,193,123;,
  3;122,124,193;,
  3;124,125,193;,
  3;123,148,22;,
  3;123,193,148;,
  3;193,149,148;,
  3;193,125,149;,
  3;125,23,149;,
  3;10,128,126;,
  3;126,194,127;,
  3;126,128,194;,
  3;128,129,194;,
  3;127,150,23;,
  3;127,194,150;,
  3;194,151,150;,
  3;194,129,151;,
  3;129,24,151;,
  3;15,132,130;,
  3;130,195,131;,
  3;130,132,195;,
  3;132,133,195;,
  3;131,152,24;,
  3;131,195,152;,
  3;195,153,152;,
  3;195,133,153;,
  3;133,25,153;;

  MeshNormals  {
   196;
   0.000000;1.000000;0.000000;,
   0.056277;0.983277;0.173202;,
   0.182116;0.983277;0.000000;,
   0.242132;0.954162;0.175919;,
   0.359628;0.933096;0.000000;,
   0.111131;0.933096;0.342026;,
   0.426135;0.886395;0.180868;,
   0.525731;0.850651;0.000000;,
   0.303699;0.886395;0.349387;,
   0.162460;0.850651;0.500000;,
   -0.147335;0.983277;0.107045;,
   -0.092486;0.954162;0.284643;,
   -0.290945;0.933096;0.211384;,
   -0.040333;0.886395;0.461170;,
   -0.238439;0.886395;0.396801;,
   -0.425325;0.850651;0.309017;,
   -0.147335;0.983277;-0.107045;,
   -0.299291;0.954162;-0.000000;,
   -0.290945;0.933096;-0.211384;,
   -0.451062;0.886395;0.104151;,
   -0.451062;0.886395;-0.104151;,
   -0.425325;0.850651;-0.309017;,
   0.056277;0.983277;-0.173202;,
   -0.092486;0.954162;-0.284643;,
   0.111131;0.933096;-0.342026;,
   -0.238439;0.886395;-0.396801;,
   -0.040332;0.886395;-0.461170;,
   0.162460;0.850651;-0.500000;,
   0.242131;0.954162;-0.175919;,
   0.303698;0.886395;-0.349387;,
   0.426135;0.886395;-0.180868;,
   0.688191;0.525731;0.500000;,
   0.657522;0.667403;0.349626;,
   0.535699;0.667403;0.517300;,
   0.492226;0.793611;0.357623;,
   0.357596;0.777986;0.516588;,
   0.601808;0.777986;0.180460;,
   -0.262866;0.525731;0.809017;,
   -0.129329;0.667403;0.733381;,
   -0.326441;0.667403;0.669335;,
   -0.188014;0.793611;0.578647;,
   -0.380801;0.777986;0.499729;,
   0.014341;0.777986;0.628118;,
   -0.850651;0.525731;-0.000000;,
   -0.737451;0.667403;0.103628;,
   -0.737451;0.667403;-0.103628;,
   -0.608425;0.793611;-0.000000;,
   -0.592944;0.777986;-0.207738;,
   -0.592945;0.777986;0.207738;,
   -0.262866;0.525731;-0.809017;,
   -0.326441;0.667403;-0.669335;,
   -0.129329;0.667403;-0.733381;,
   -0.188014;0.793611;-0.578647;,
   0.014341;0.777986;-0.628118;,
   -0.380801;0.777986;-0.499729;,
   0.688191;0.525731;-0.500000;,
   0.535699;0.667403;-0.517300;,
   0.657522;0.667403;-0.349626;,
   0.492226;0.793611;-0.357623;,
   0.601808;0.777986;-0.180460;,
   0.357596;0.777986;-0.516588;,
   0.673629;0.739069;0.000000;,
   0.743522;0.645045;-0.176327;,
   0.798051;0.602590;0.000000;,
   0.785072;0.516652;-0.341662;,
   0.854147;0.490169;-0.173687;,
   0.894427;0.447214;0.000000;,
   0.743522;0.645045;0.176328;,
   0.854147;0.490169;0.173687;,
   0.785072;0.516652;0.341662;,
   0.208163;0.739069;0.640659;,
   0.397458;0.645045;0.652644;,
   0.246611;0.602590;0.758992;,
   0.567540;0.516652;0.641068;,
   0.429133;0.490169;0.758670;,
   0.276393;0.447214;0.850651;,
   0.062063;0.645045;0.761620;,
   0.098759;0.490169;0.866014;,
   -0.082339;0.516652;0.852227;,
   -0.544978;0.739069;0.395949;,
   -0.497879;0.645045;0.579683;,
   -0.645637;0.602590;0.469082;,
   -0.434313;0.516652;0.737864;,
   -0.588928;0.490169;0.642571;,
   -0.723607;0.447214;0.525731;,
   -0.705165;0.645045;0.294379;,
   -0.793110;0.490169;0.361538;,
   -0.835960;0.516652;0.185043;,
   -0.544977;0.739069;-0.395949;,
   -0.705165;0.645045;-0.294379;,
   -0.645637;0.602590;-0.469083;,
   -0.835960;0.516652;-0.185043;,
   -0.793110;0.490169;-0.361539;,
   -0.723607;0.447214;-0.525731;,
   -0.497879;0.645045;-0.579683;,
   -0.588928;0.490169;-0.642571;,
   -0.434313;0.516652;-0.737864;,
   0.208163;0.739069;-0.640659;,
   0.062064;0.645045;-0.761620;,
   0.246611;0.602590;-0.758992;,
   -0.082339;0.516652;-0.852227;,
   0.098759;0.490169;-0.866014;,
   0.276393;0.447214;-0.850651;,
   0.397458;0.645045;-0.652643;,
   0.429133;0.490169;-0.758669;,
   0.567540;0.516652;-0.641068;,
   0.946773;0.073666;0.313360;,
   0.964772;0.156854;0.211218;,
   0.899591;0.182420;0.396812;,
   0.894922;0.342246;0.286326;,
   0.810661;0.361125;0.460888;,
   0.945270;0.308143;0.107296;,
   0.590592;0.073666;0.803601;,
   0.655379;0.182420;0.732940;,
   0.499011;0.156854;0.852282;,
   0.548858;0.342246;0.762642;,
   0.394149;0.308143;0.865849;,
   0.688839;0.361125;0.628562;,
   -0.005454;0.073666;0.997268;,
   0.097251;0.156854;0.982822;,
   -0.099402;0.182420;0.978183;,
   0.004234;0.342246;0.939601;,
   -0.187823;0.361125;0.913407;,
   0.190060;0.308143;0.932162;,
   -0.581767;0.073666;0.810013;,
   -0.494544;0.182420;0.849794;,
   -0.656366;0.156854;0.737957;,
   -0.555709;0.342246;0.757664;,
   -0.701672;0.308143;0.642420;,
   -0.384935;0.361125;0.849361;,
   -0.950144;0.073666;0.302985;,
   -0.904667;0.156854;0.396200;,
   -0.961024;0.182420;0.207739;,
   -0.892305;0.342246;0.294379;,
   -0.926742;0.361125;0.103628;,
   -0.827807;0.308143;0.468812;,
   -0.950144;0.073666;-0.302985;,
   -0.961024;0.182420;-0.207739;,
   -0.904667;0.156854;-0.396200;,
   -0.892305;0.342246;-0.294379;,
   -0.827807;0.308143;-0.468812;,
   -0.926742;0.361125;-0.103628;,
   -0.581767;0.073666;-0.810013;,
   -0.656366;0.156854;-0.737957;,
   -0.494544;0.182420;-0.849794;,
   -0.555709;0.342246;-0.757665;,
   -0.384935;0.361125;-0.849361;,
   -0.701672;0.308143;-0.642420;,
   -0.005454;0.073666;-0.997268;,
   -0.099402;0.182420;-0.978183;,
   0.097251;0.156854;-0.982822;,
   0.004234;0.342246;-0.939601;,
   0.190060;0.308143;-0.932162;,
   -0.187823;0.361124;-0.913407;,
   0.590592;0.073666;-0.803601;,
   0.499011;0.156854;-0.852282;,
   0.655379;0.182420;-0.732940;,
   0.548858;0.342245;-0.762642;,
   0.688839;0.361125;-0.628562;,
   0.394149;0.308143;-0.865849;,
   0.946773;0.073666;-0.313360;,
   0.899591;0.182420;-0.396811;,
   0.964772;0.156854;-0.211217;,
   0.894922;0.342245;-0.286326;,
   0.945270;0.308143;-0.107296;,
   0.810661;0.361124;-0.460888;,
   0.987275;0.159020;0.000000;,
   0.991995;0.071711;-0.103942;,
   0.991995;0.071710;0.103943;,
   0.794393;0.189278;0.577160;,
   0.862613;0.085823;0.498530;,
   0.740693;0.085823;0.666340;,
   0.305085;0.159020;0.938955;,
   0.405398;0.071711;0.911323;,
   0.207688;0.071710;0.975563;,
   -0.303431;0.189278;0.933865;,
   -0.207568;0.085822;0.974449;,
   -0.404840;0.085822;0.910351;,
   -0.798722;0.159020;0.580306;,
   -0.741445;0.071711;0.667171;,
   -0.863636;0.071711;0.498989;,
   -0.981923;0.189278;-0.000000;,
   -0.990898;0.085822;0.103712;,
   -0.990898;0.085823;-0.103712;,
   -0.798722;0.159021;-0.580306;,
   -0.863636;0.071711;-0.498989;,
   -0.741445;0.071711;-0.667171;,
   -0.303431;0.189278;-0.933865;,
   -0.404840;0.085823;-0.910351;,
   -0.207568;0.085823;-0.974449;,
   0.305085;0.159020;-0.938955;,
   0.207688;0.071711;-0.975563;,
   0.405398;0.071710;-0.911323;,
   0.794393;0.189278;-0.577160;,
   0.740693;0.085822;-0.666340;,
   0.862614;0.085822;-0.498530;;
   360;
   3;0,1,2;,
   3;2,3,4;,
   3;2,1,3;,
   3;1,5,3;,
   3;4,6,7;,
   3;4,3,6;,
   3;3,8,6;,
   3;3,5,8;,
   3;5,9,8;,
   3;0,10,1;,
   3;1,11,5;,
   3;1,10,11;,
   3;10,12,11;,
   3;5,13,9;,
   3;5,11,13;,
   3;11,14,13;,
   3;11,12,14;,
   3;12,15,14;,
   3;0,16,10;,
   3;10,17,12;,
   3;10,16,17;,
   3;16,18,17;,
   3;12,19,15;,
   3;12,17,19;,
   3;17,20,19;,
   3;17,18,20;,
   3;18,21,20;,
   3;0,22,16;,
   3;16,23,18;,
   3;16,22,23;,
   3;22,24,23;,
   3;18,25,21;,
   3;18,23,25;,
   3;23,26,25;,
   3;23,24,26;,
   3;24,27,26;,
   3;0,2,22;,
   3;22,28,24;,
   3;22,2,28;,
   3;2,4,28;,
   3;24,29,27;,
   3;24,28,29;,
   3;28,30,29;,
   3;28,4,30;,
   3;4,7,30;,
   3;31,32,33;,
   3;33,34,35;,
   3;33,32,34;,
   3;32,36,34;,
   3;35,8,9;,
   3;35,34,8;,
   3;34,6,8;,
   3;34,36,6;,
   3;36,7,6;,
   3;37,38,39;,
   3;39,40,41;,
   3;39,38,40;,
   3;38,42,40;,
   3;41,14,15;,
   3;41,40,14;,
   3;40,13,14;,
   3;40,42,13;,
   3;42,9,13;,
   3;43,44,45;,
   3;45,46,47;,
   3;45,44,46;,
   3;44,48,46;,
   3;47,20,21;,
   3;47,46,20;,
   3;46,19,20;,
   3;46,48,19;,
   3;48,15,19;,
   3;49,50,51;,
   3;51,52,53;,
   3;51,50,52;,
   3;50,54,52;,
   3;53,26,27;,
   3;53,52,26;,
   3;52,25,26;,
   3;52,54,25;,
   3;54,21,25;,
   3;55,56,57;,
   3;57,58,59;,
   3;57,56,58;,
   3;56,60,58;,
   3;59,30,7;,
   3;59,58,30;,
   3;58,29,30;,
   3;58,60,29;,
   3;60,27,29;,
   3;7,61,59;,
   3;59,62,57;,
   3;59,61,62;,
   3;61,63,62;,
   3;57,64,55;,
   3;57,62,64;,
   3;62,65,64;,
   3;62,63,65;,
   3;63,66,65;,
   3;7,36,61;,
   3;61,67,63;,
   3;61,36,67;,
   3;36,32,67;,
   3;63,68,66;,
   3;63,67,68;,
   3;67,69,68;,
   3;67,32,69;,
   3;32,31,69;,
   3;9,70,35;,
   3;35,71,33;,
   3;35,70,71;,
   3;70,72,71;,
   3;33,73,31;,
   3;33,71,73;,
   3;71,74,73;,
   3;71,72,74;,
   3;72,75,74;,
   3;9,42,70;,
   3;70,76,72;,
   3;70,42,76;,
   3;42,38,76;,
   3;72,77,75;,
   3;72,76,77;,
   3;76,78,77;,
   3;76,38,78;,
   3;38,37,78;,
   3;15,79,41;,
   3;41,80,39;,
   3;41,79,80;,
   3;79,81,80;,
   3;39,82,37;,
   3;39,80,82;,
   3;80,83,82;,
   3;80,81,83;,
   3;81,84,83;,
   3;15,48,79;,
   3;79,85,81;,
   3;79,48,85;,
   3;48,44,85;,
   3;81,86,84;,
   3;81,85,86;,
   3;85,87,86;,
   3;85,44,87;,
   3;44,43,87;,
   3;21,88,47;,
   3;47,89,45;,
   3;47,88,89;,
   3;88,90,89;,
   3;45,91,43;,
   3;45,89,91;,
   3;89,92,91;,
   3;89,90,92;,
   3;90,93,92;,
   3;21,54,88;,
   3;88,94,90;,
   3;88,54,94;,
   3;54,50,94;,
   3;90,95,93;,
   3;90,94,95;,
   3;94,96,95;,
   3;94,50,96;,
   3;50,49,96;,
   3;27,97,53;,
   3;53,98,51;,
   3;53,97,98;,
   3;97,99,98;,
   3;51,100,49;,
   3;51,98,100;,
   3;98,101,100;,
   3;98,99,101;,
   3;99,102,101;,
   3;27,60,97;,
   3;97,103,99;,
   3;97,60,103;,
   3;60,56,103;,
   3;99,104,102;,
   3;99,103,104;,
   3;103,105,104;,
   3;103,56,105;,
   3;56,55,105;,
   3;106,107,108;,
   3;108,109,110;,
   3;108,107,109;,
   3;107,111,109;,
   3;110,69,31;,
   3;110,109,69;,
   3;109,68,69;,
   3;109,111,68;,
   3;111,66,68;,
   3;112,113,114;,
   3;114,115,116;,
   3;114,113,115;,
   3;113,117,115;,
   3;116,74,75;,
   3;116,115,74;,
   3;115,73,74;,
   3;115,117,73;,
   3;117,31,73;,
   3;118,119,120;,
   3;120,121,122;,
   3;120,119,121;,
   3;119,123,121;,
   3;122,78,37;,
   3;122,121,78;,
   3;121,77,78;,
   3;121,123,77;,
   3;123,75,77;,
   3;124,125,126;,
   3;126,127,128;,
   3;126,125,127;,
   3;125,129,127;,
   3;128,83,84;,
   3;128,127,83;,
   3;127,82,83;,
   3;127,129,82;,
   3;129,37,82;,
   3;130,131,132;,
   3;132,133,134;,
   3;132,131,133;,
   3;131,135,133;,
   3;134,87,43;,
   3;134,133,87;,
   3;133,86,87;,
   3;133,135,86;,
   3;135,84,86;,
   3;136,137,138;,
   3;138,139,140;,
   3;138,137,139;,
   3;137,141,139;,
   3;140,92,93;,
   3;140,139,92;,
   3;139,91,92;,
   3;139,141,91;,
   3;141,43,91;,
   3;142,143,144;,
   3;144,145,146;,
   3;144,143,145;,
   3;143,147,145;,
   3;146,96,49;,
   3;146,145,96;,
   3;145,95,96;,
   3;145,147,95;,
   3;147,93,95;,
   3;148,149,150;,
   3;150,151,152;,
   3;150,149,151;,
   3;149,153,151;,
   3;152,101,102;,
   3;152,151,101;,
   3;151,100,101;,
   3;151,153,100;,
   3;153,49,100;,
   3;154,155,156;,
   3;156,157,158;,
   3;156,155,157;,
   3;155,159,157;,
   3;158,105,55;,
   3;158,157,105;,
   3;157,104,105;,
   3;157,159,104;,
   3;159,102,104;,
   3;160,161,162;,
   3;162,163,164;,
   3;162,161,163;,
   3;161,165,163;,
   3;164,65,66;,
   3;164,163,65;,
   3;163,64,65;,
   3;163,165,64;,
   3;165,55,64;,
   3;66,111,164;,
   3;164,166,162;,
   3;164,111,166;,
   3;111,107,166;,
   3;162,167,160;,
   3;162,166,167;,
   3;166,168,167;,
   3;166,107,168;,
   3;107,106,168;,
   3;31,117,110;,
   3;110,169,108;,
   3;110,117,169;,
   3;117,113,169;,
   3;108,170,106;,
   3;108,169,170;,
   3;169,171,170;,
   3;169,113,171;,
   3;113,112,171;,
   3;75,123,116;,
   3;116,172,114;,
   3;116,123,172;,
   3;123,119,172;,
   3;114,173,112;,
   3;114,172,173;,
   3;172,174,173;,
   3;172,119,174;,
   3;119,118,174;,
   3;37,129,122;,
   3;122,175,120;,
   3;122,129,175;,
   3;129,125,175;,
   3;120,176,118;,
   3;120,175,176;,
   3;175,177,176;,
   3;175,125,177;,
   3;125,124,177;,
   3;84,135,128;,
   3;128,178,126;,
   3;128,135,178;,
   3;135,131,178;,
   3;126,179,124;,
   3;126,178,179;,
   3;178,180,179;,
   3;178,131,180;,
   3;131,130,180;,
   3;43,141,134;,
   3;134,181,132;,
   3;134,141,181;,
   3;141,137,181;,
   3;132,182,130;,
   3;132,181,182;,
   3;181,183,182;,
   3;181,137,183;,
   3;137,136,183;,
   3;93,147,140;,
   3;140,184,138;,
   3;140,147,184;,
   3;147,143,184;,
   3;138,185,136;,
   3;138,184,185;,
   3;184,186,185;,
   3;184,143,186;,
   3;143,142,186;,
   3;49,153,146;,
   3;146,187,144;,
   3;146,153,187;,
   3;153,149,187;,
   3;144,188,142;,
   3;144,187,188;,
   3;187,189,188;,
   3;187,149,189;,
   3;149,148,189;,
   3;102,159,152;,
   3;152,190,150;,
   3;152,159,190;,
   3;159,155,190;,
   3;150,191,148;,
   3;150,190,191;,
   3;190,192,191;,
   3;190,155,192;,
   3;155,154,192;,
   3;55,165,158;,
   3;158,193,156;,
   3;158,165,193;,
   3;165,161,193;,
   3;156,194,154;,
   3;156,193,194;,
   3;193,195,194;,
   3;193,161,195;,
   3;161,160,195;;
  }

  MeshMaterialList  {
   1;
   360;
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0;
   { PDX01_-_Default }
  }

  MeshTextureCoords  {
   196;
   0.500000;0.500000;,
   0.500000;0.333746;,
   0.341883;0.448625;,
   0.402278;0.634503;,
   0.597722;0.634503;,
   0.658117;0.448625;,
   0.500000;0.167491;,
   0.183765;0.397249;,
   0.304556;0.769005;,
   0.695444;0.769005;,
   0.816234;0.397249;,
   0.320431;0.252844;,
   0.209451;0.594405;,
   0.500000;0.805501;,
   0.790549;0.594405;,
   0.679569;0.252845;,
   0.354220;0.051334;,
   0.118342;0.222709;,
   0.028245;0.500000;,
   0.118342;0.777291;,
   0.354219;0.948666;,
   0.645780;0.948666;,
   0.881658;0.777291;,
   0.971755;0.500000;,
   0.881658;0.222709;,
   0.645780;0.051334;,
   0.500000;0.444582;,
   0.500000;0.389164;,
   0.447294;0.482875;,
   0.394588;0.465750;,
   0.467426;0.544834;,
   0.434852;0.589668;,
   0.532574;0.544834;,
   0.565148;0.589668;,
   0.552706;0.482875;,
   0.605412;0.465750;,
   0.444837;0.368608;,
   0.392085;0.406934;,
   0.357992;0.511861;,
   0.378142;0.573874;,
   0.467397;0.638722;,
   0.532602;0.638722;,
   0.621858;0.573874;,
   0.642007;0.511861;,
   0.607915;0.406935;,
   0.555163;0.368608;,
   0.500000;0.278328;,
   0.500000;0.222909;,
   0.289177;0.431499;,
   0.236471;0.414374;,
   0.369704;0.679337;,
   0.337130;0.724171;,
   0.630296;0.679337;,
   0.662870;0.724171;,
   0.710823;0.431499;,
   0.763529;0.414374;,
   0.442494;0.302563;,
   0.382654;0.275416;,
   0.294456;0.493680;,
   0.250146;0.542203;,
   0.430472;0.693531;,
   0.462928;0.750667;,
   0.662573;0.625929;,
   0.726942;0.612718;,
   0.670003;0.384298;,
   0.677330;0.318997;,
   0.557505;0.302563;,
   0.617346;0.275416;,
   0.329997;0.384298;,
   0.322670;0.318997;,
   0.337427;0.625929;,
   0.273058;0.612718;,
   0.569527;0.693531;,
   0.537072;0.750667;,
   0.705544;0.493680;,
   0.749854;0.542203;,
   0.436361;0.188591;,
   0.376315;0.217225;,
   0.184167;0.464294;,
   0.192844;0.530249;,
   0.368443;0.789341;,
   0.433852;0.801470;,
   0.734527;0.714529;,
   0.766274;0.656070;,
   0.776502;0.343245;,
   0.730715;0.294986;,
   0.623685;0.217225;,
   0.563639;0.188591;,
   0.269285;0.294986;,
   0.223498;0.343245;,
   0.233725;0.656070;,
   0.265473;0.714529;,
   0.566148;0.801470;,
   0.631556;0.789341;,
   0.807156;0.530249;,
   0.815833;0.464294;,
   0.457158;0.124348;,
   0.408836;0.085211;,
   0.324070;0.185996;,
   0.334753;0.118688;,
   0.255729;0.235648;,
   0.188414;0.225009;,
   0.155973;0.343172;,
   0.133684;0.285121;,
   0.129495;0.424663;,
   0.077341;0.458526;,
   0.146999;0.570287;,
   0.086286;0.539327;,
   0.173102;0.650626;,
   0.142183;0.711359;,
   0.244537;0.778727;,
   0.182440;0.781986;,
   0.313857;0.829091;,
   0.329947;0.889156;,
   0.457763;0.857444;,
   0.409557;0.905618;,
   0.542236;0.857444;,
   0.590442;0.905618;,
   0.686142;0.829091;,
   0.670053;0.889156;,
   0.755463;0.778727;,
   0.817560;0.781986;,
   0.826898;0.650626;,
   0.857817;0.711359;,
   0.853001;0.570287;,
   0.913714;0.539327;,
   0.870505;0.424663;,
   0.922659;0.458526;,
   0.844027;0.343172;,
   0.866316;0.285121;,
   0.744270;0.235648;,
   0.811586;0.225009;,
   0.675930;0.185996;,
   0.665247;0.118688;,
   0.542842;0.124348;,
   0.591164;0.085211;,
   0.264122;0.091448;,
   0.184334;0.149417;,
   0.069030;0.308120;,
   0.038554;0.401916;,
   0.038554;0.598083;,
   0.069030;0.691880;,
   0.184334;0.850583;,
   0.264122;0.908552;,
   0.450688;0.969171;,
   0.549312;0.969171;,
   0.735878;0.908552;,
   0.815666;0.850583;,
   0.930970;0.691880;,
   0.961446;0.598084;,
   0.961446;0.401917;,
   0.930970;0.308120;,
   0.815666;0.149417;,
   0.735878;0.091448;,
   0.549312;0.030829;,
   0.450688;0.030829;,
   0.446467;0.426318;,
   0.413382;0.528144;,
   0.500000;0.591075;,
   0.586618;0.528144;,
   0.553533;0.426318;,
   0.384342;0.340810;,
   0.312861;0.560805;,
   0.500000;0.696770;,
   0.687139;0.560805;,
   0.615659;0.340810;,
   0.560192;0.246113;,
   0.439808;0.246113;,
   0.277140;0.364299;,
   0.239939;0.478791;,
   0.302073;0.670018;,
   0.399466;0.740779;,
   0.600534;0.740779;,
   0.697927;0.670018;,
   0.760061;0.478791;,
   0.722860;0.364299;,
   0.388023;0.150384;,
   0.202098;0.285466;,
   0.132892;0.498459;,
   0.203909;0.717027;,
   0.385092;0.848664;,
   0.614908;0.848664;,
   0.796091;0.717027;,
   0.867108;0.498459;,
   0.797902;0.285466;,
   0.611977;0.150384;,
   0.500000;0.076416;,
   0.256520;0.164879;,
   0.097148;0.369105;,
   0.106042;0.628005;,
   0.251023;0.842687;,
   0.500000;0.914232;,
   0.748976;0.842687;,
   0.893958;0.628005;,
   0.902852;0.369105;,
   0.743479;0.164879;;
  }
 }
}