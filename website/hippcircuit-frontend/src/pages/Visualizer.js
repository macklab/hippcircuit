import './Visualizer.css';

import glbtest from '../models/test.glb';

import { Canvas } from "@react-three/fiber";
import { OrbitControls } from '@react-three/drei';
import { Suspense } from "react";

import { useLoader } from '@react-three/fiber'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'


// A test box for trying some orbit controls

function Box() {
    return (
        <mesh>
            <boxBufferGeometry attach='geometry' />
            <meshDepthMaterial attach='material' color='green' />
        </mesh>
    )
}

const Model = () => {
  const gltf = useLoader(GLTFLoader, glbtest);
  return (
    <>
      <ambientLight color="blue" intensity={1}/>
      <pointLight position={[10, 20, 10]} intensity={1} color="red"/>
      <pointLight position={[-10, -20, -10]} intensity={1} color="red"/>
      <primitive object={gltf.scene} scale={0.1} />
    </>
  );
};

function Visualizer() {
  return (
    <div className="visualizercontainer">
      <div className='vistop'>
          <Canvas>
            <Suspense fallback={null}>
              <OrbitControls />
              <Model />
            </Suspense>
          </Canvas>
      </div>
      <div className='visbot'>

      </div>
    </div>
  );
}


export default Visualizer;