import './App.css'

import { NoiseFilter } from 'pixi.js';
import { Stage, Sprite } from '@pixi/react';
import { useMemo } from 'react';

export const MyComponent = () => {
  const noiseFilter = useMemo(() => new NoiseFilter(100), []);

  return (
    <Stage options={{ hello: true }}>
      <Sprite
        image="https://pixijs.io/pixi-react/img/bunny.png"
        x={400}
        y={270}
        width={500}
        height={500}
        anchor={{ x: 0.5, y: 0.5 }}
        filters={[noiseFilter]}
      />

    </Stage>
  );
};

function App() {

  return (
    <>
      <MyComponent />
    </>
  )
}

export default App
