using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace NF.Shader.Easing
{
    public class SRP_SandBox : ScriptableRendererFeature
    {
        public class Pass_SandBox : ScriptableRenderPass
        {
            SRP_SandBox _feature;
            RenderTargetIdentifier _CameraSource;
            // ========================
            Vector2Int _texSize = Vector2Int.zero;
            RenderTexture _BlitBuffer = null;
            RenderTexture _BackBuffer = null;

            public Pass_SandBox(SRP_SandBox feature)
            {
                _feature = feature;
            }


            public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
            {
                CheckResolutionChanged(cameraTextureDescriptor.width, cameraTextureDescriptor.height, out bool isChanged);
                if (isChanged)
                {
                }
            }

            public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
            {
                this._feature.Material.SetVector("_E_Mouse", new Vector4(Input.mousePosition.x / _texSize.x * 2 - 1, Input.mousePosition.y / _texSize.y * 2 - 1));
                this._feature.Material.SetFloat("_E_Time", Time.time);

                CommandBuffer cmd = CommandBufferPool.Get(nameof(Pass_SandBox));
                {
                    cmd.Blit(_CameraSource, _BlitBuffer, this._feature.Material);
                    cmd.Blit(_BlitBuffer, _BackBuffer);
                    cmd.Blit(_BlitBuffer, _CameraSource);
                    context.ExecuteCommandBuffer(cmd);
                }
                CommandBufferPool.Release(cmd);
            }

            public void SetSource(RenderTargetIdentifier cameraColorTarget)
            {
                this._CameraSource = cameraColorTarget;
            }

            // ==============================================
            void CheckResolutionChanged(int width, int height, out bool isChanged)
            {
                if (width != _texSize.x || height != _texSize.y)
                {
                    isChanged = true;
                    CreateTextures(width, height);
                }
                else
                {
                    isChanged = false;
                }
            }

            void CreateTextures(int width, int height)
            {
                _texSize.x = width;
                _texSize.y = height;

                this._feature.Material.SetVector("_E_Resolution", new Vector4(_texSize.x, _texSize.y, 0, 0));

                ClearTextures();
                CreateTexture(ref _BlitBuffer);
                CreateTexture(ref _BackBuffer);

                _feature.Material.SetTexture("_E_BackbufferTex", _BackBuffer);
            }

            void CreateTexture(ref RenderTexture textureToMake, int divide = 1)
            {
                textureToMake = new RenderTexture(_texSize.x / divide, _texSize.y / divide, 0,
                    format: RenderTextureFormat.ARGB32,
                    readWrite: RenderTextureReadWrite.Linear)
                {
                    enableRandomWrite = true
                };
                textureToMake.Create();
            }

            void ClearTexture(ref RenderTexture textureToClear)
            {
                if (textureToClear != null)
                {
                    textureToClear.Release();
                    textureToClear = null;
                }
            }

            void ClearTextures()
            {
                ClearTexture(ref _BlitBuffer);
                ClearTexture(ref _BackBuffer);
            }
        }

        public Material Material = null;
        Pass_SandBox _scriptablePass;

        public override void Create()
        {

            _scriptablePass = new Pass_SandBox(this);
            _scriptablePass.renderPassEvent = RenderPassEvent.AfterRendering;
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            _scriptablePass.SetSource(renderer.cameraColorTarget);
            renderer.EnqueuePass(_scriptablePass);
        }
    }

}
