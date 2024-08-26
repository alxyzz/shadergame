Shader "Custom/EyeShader"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _LineColor ("Line Color", Color) = (0,0,0,1)
        _Frequency ("Frequency", Float) = 10.0
        _Speed ("Speed", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _Frequency;
            float _Speed;
            float4 _MainColor;
            float4 _LineColor;
            float _RunTime;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 center = float2(0.5, 0.5);
                float dist = distance(i.uv, center);
                float angle = dist * _Frequency - _RunTime * _Speed;
                float l = smoothstep(0.45, 0.55, sin(angle * 6.28));
                fixed4 col = lerp(_LineColor, _MainColor, l);
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
