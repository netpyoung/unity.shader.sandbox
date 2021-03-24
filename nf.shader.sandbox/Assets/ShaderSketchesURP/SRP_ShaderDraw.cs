using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

namespace NF.ShaderSketchesURP
{
    public class SRP_ShaderDraw : ScriptableRendererFeature
    {
        public class Pass_ShaderDraw : ScriptableRenderPass
        {
            SRP_ShaderDraw _feature;
            RenderTargetIdentifier _CameraSource;

            public Pass_ShaderDraw(SRP_ShaderDraw feature)
            {
                this._feature = feature;
            }

            public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
            {
                CommandBuffer cmd = CommandBufferPool.Get(nameof(Pass_ShaderDraw));
                {
                    cmd.Blit(null, _CameraSource, this._feature.Material);
                    context.ExecuteCommandBuffer(cmd);
                }
                CommandBufferPool.Release(cmd);
            }

            public void SetSource(RenderTargetIdentifier cameraColorTarget)
            {
                this._CameraSource = cameraColorTarget;
            }
        }

        public Material Material = null;

        Pass_ShaderDraw _scriptablePass;

        public override void Create()
        {

            _scriptablePass = new Pass_ShaderDraw(this);
            _scriptablePass.renderPassEvent = RenderPassEvent.AfterRendering;
        }

        public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
        {
            _scriptablePass.SetSource(renderer.cameraColorTarget);
            renderer.EnqueuePass(_scriptablePass);
        }
    }

}
