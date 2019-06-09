Shader "Unlit/SampleTime"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                // (1, 1, -1)の座標にある頂点を1秒ごと0.5ずつ頂点を変化させる
                if (v.vertex.x > 0 && v.vertex.y > 0 && v.vertex.z < 0) {
                    v.vertex.xy += (floor(_Time.y) % 2 == 0) ? min(0.5, frac(_Time.y)) : min(0.5 , min(1 - frac(_Time.y), 0.5));
                }
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // R値を1秒ごと変化させる
                fixed4 col = fixed4((floor(_Time.y) % 2 == 0) ? frac(_Time.y) : (1- frac(_Time.y)), i.uv.y, 0, 1);
                return col;
            }
            ENDCG
        }
    }
}
