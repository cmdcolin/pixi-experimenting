import fragment from './shader.glsl'
import * as PIXI from 'pixi.js'

/**
 * Please note that this is not the most optimal way of doing pure shader
 * generated rendering and should be used when the scene is wanted as input
 * texture. Check the mesh version of example for more performant version if
 * you need only shader generated content.
 **/
const app = new PIXI.Application({ background: '#ccc', resizeTo: window })

document.body.appendChild(app.view)

PIXI.Assets.load('/cat.jpg').then(onAssetsLoaded)

// const text = new PIXI.Text('cat', { fill: 0xffffff, fontSize: 1000 })

// text.anchor.set(0.5, 0.5)
// text.position.set(app.renderer.screen.width / 2, app.renderer.screen.height / 2)

// app.stage.addChild(text)

let totalTime = 0

function onAssetsLoaded(perlin: PIXI.ResolvedAsset) {
  // Add perlin noise for filter, make sure it's wrapping and does not have
  // mipmap.
  perlin.baseTexture.wrapMode = PIXI.WRAP_MODES.CLAMP
  perlin.baseTexture.mipmap = false

  // Build the filter
  const filter = new PIXI.Filter(undefined, fragment, {
    time: 0.0,
    noise: perlin,
  })
  app.stage.filterArea = app.renderer.screen
  const n = new PIXI.NoiseFilter(100)
  app.stage.filters = [n, filter]

  app.ticker.add(delta => {
    filter.uniforms.time = totalTime
    totalTime += delta / 60
  })
}

export default () => {
  return <div />
}
