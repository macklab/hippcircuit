import { useLoader } from '@react-three/fiber'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import { Suspense } from 'react'

export default function Model(props) {
    const gltf = useLoader(GLTFLoader, props.model);

  return (
    <>
    <Suspense fallback={null}>
      <ambientLight color="blue" intensity={1}/>
      <pointLight position={[10, 20, 10]} intensity={1} color="red"/>
      <pointLight position={[-10, -20, -10]} intensity={1} color="red"/>
      <primitive object={gltf.scene} scale={0.1} />
    </Suspense>
    </>
  );
}