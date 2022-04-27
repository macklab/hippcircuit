import './Visualizer.css';

import glbtest from '../models/test.glb';
import glbtest2 from '../models/test2.glb';

import { Canvas } from "@react-three/fiber";
import { OrbitControls } from '@react-three/drei';
import { Suspense, useState } from "react";
import Carousel from 'react-elastic-carousel'

import Model from '../components/Model';
import ModelCard from '../components/ModelCard';


const Model1 = () => {
  return (
    <Model model={glbtest} />
  )
};

const Model2 = () => {
  return (
    <Model model={glbtest2} />
  )
};


const cardData = [
  {
    id: 1,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 2,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 3,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 4,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 5,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 6,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 7,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 8,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 9,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 10,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 11,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 12,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 13,
    url: Model1,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 14,
    url: Model2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
];


function Visualizer() {

  const [model, setModel] = useState(Model1);

  const [titleText, setTitleText] = useState('ROIs: CA1 to CA2CA3')
  const [sideText, setSideText] = useState('Hemisphere: Left')

  return (
    <div className="visualizercontainer">
      <div className='vistop'>
          <div className='infobox'>
            <h1>{titleText}</h1>
            <h2>{sideText}</h2>
            <h2>N-Tracts: 724</h2>
            <h2>Stat1: X</h2>
            <h2>Stat2: Y</h2>
            <h2>Stat3: Z</h2>
          </div>
          <Canvas>
            <Suspense fallback={null}>
              <OrbitControls />
              {model}
            </Suspense>
          </Canvas>
      </div>
      <div className='visbot'>
        <Carousel itemsToShow={6}>
        {cardData.map((card) =>
          <div key={card.id} onClick={() => {
              setModel(card.url)
              setTitleText(`ROIs: ${card.firstROI} to ${card.secondROI}`)
              setSideText(`Hemisphere: ${card.side}`)
              }}>
            <ModelCard side={card.side} 
                       firstROI={card.firstROI} 
                       secondROI={card.secondROI}
            />
          </div>
        )}
        </Carousel>
      </div>
    </div>
  );
}


export default Visualizer;