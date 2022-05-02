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
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 2,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 3,
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 4,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 5,
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 6,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 7,
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 8,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 9,
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 10,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 11,
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 12,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 13,
    url: 'Model1',
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 14,
    url: 'Model2',
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
];


function Visualizer() {

  const [model, setModel] = useState(Model1);

  const [model1, setModel1] = useState(true);
  const [model2, setModel2] = useState(false);
  const [model3, setModel3] = useState(false);
  const [model4, setModel4] = useState(false);
  const [model5, setModel5] = useState(false);
  const [model6, setModel6] = useState(false);
  const [model7, setModel7] = useState(false);
  const [model8, setModel8] = useState(false);
  const [model9, setModel9] = useState(false);
  const [model10, setModel10] = useState(false);
  const [model11, setModel11] = useState(false);
  const [model12, setModel12] = useState(false);
  const [model13, setModel13] = useState(false);
  const [model14, setModel14] = useState(false);

  const [titleText, setTitleText] = useState('ROIs: CA1 to CA2CA3')
  const [sideText, setSideText] = useState('Hemisphere: Left')


  const setFalse = (deselected) => {
    if (deselected === 'Model1') {
      setModel1(false)
    } else if (deselected === 'Model2') {
      setModel2(false)
    } else if (deselected === 'Model3') {
      setModel3(false)
    } else if (deselected === 'Model4') {
      setModel4(false)
    } else if (deselected === 'Model5') {
      setModel5(false)
    } else if (deselected === 'Model6') {
      setModel6(false)
    } else if (deselected === 'Model7') {
      setModel7(false)
    } else if (deselected === 'Model8') {
      setModel8(false)
    } else if (deselected === 'Model9') {
      setModel9(false)
    } else if (deselected === 'Model10') {
      setModel10(false)
    } else if (deselected === 'Model11') {
      setModel11(false)
    } else if (deselected === 'Model12') {
      setModel12(false)
    } else if (deselected === 'Model13') {
      setModel13(false)
    } else if (deselected === 'Model14') {
      setModel14(false)
    }
  };

  const setTrue = (selected) => {
    if (selected === 'Model1') {
      setModel1(true)
    } else if (selected === 'Model2') {
      setModel2(true)
    } else if (selected === 'Model3') {
      setModel3(true)
    } else if (selected === 'Model4') {
      setModel4(true)
    } else if (selected === 'Model5') {
      setModel5(true)
    } else if (selected === 'Model6') {
      setModel6(true)
    } else if (selected === 'Model7') {
      setModel7(true)
    } else if (selected === 'Model8') {
      setModel8(true)
    } else if (selected === 'Model9') {
      setModel9(true)
    } else if (selected === 'Model10') {
      setModel10(true)
    } else if (selected === 'Model11') {
      setModel11(true)
    } else if (selected === 'Model12') {
      setModel12(true)
    } else if (selected === 'Model13') {
      setModel13(true)
    } else if (selected === 'Model14') {
      setModel14(true)
    }
  };

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
              {model1 ? <Model1 /> : <></>}
              {model2 ? <Model2 /> : <></>}
            </Suspense>
          </Canvas>
      </div>
      <div className='visbot'>
        <Carousel itemsToShow={6}>
        {cardData.map((card) =>
          <div key={card.id} onClick={() => {
              setTrue(card.url)
              setFalse(model)
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