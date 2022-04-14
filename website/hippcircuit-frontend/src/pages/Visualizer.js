import './Visualizer.css';

import { Canvas } from "@react-three/fiber";
import { OrbitControls } from '@react-three/drei';


function Box() {
    return (
        <mesh>
            <boxBufferGeometry attach='geometry' />
            <meshDepthMaterial attach='material' color='green' />
        </mesh>
    )
}

function Visualizer() {
  return (
    <div className="visualizercontainer">
      <div className='vistop'>
          <Canvas>
              <OrbitControls />
              <Box />
          </Canvas>
      </div>
      <div className='visbot'>

      </div>
    </div>
  );
}


export default Visualizer;