import { Canvas } from "@react-three/fiber";
import { OrbitControls } from '@react-three/drei';
import { useLoader } from '@react-three/fiber';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { Suspense } from "react";

export default function ModelCanvas(props) {

    const gltf = useLoader(GLTFLoader, props.model);

  return (
    <Canvas>
        <OrbitControls />
        <Suspense fallback={<></>}>
            <>
                <ambientLight color="white" intensity={0.5}/>
                <pointLight position={[10, 20, 10]} intensity={0.5} color="white"/>
                <pointLight position={[-10, -20, -10]} intensity={0.5} color="white"/>
                <primitive object={gltf.scene} scale={0.1}/>

            </>
        </Suspense>
    </Canvas>
  );
}
