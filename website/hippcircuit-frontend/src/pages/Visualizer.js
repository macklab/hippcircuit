import './Visualizer.css';

import glbtest from '../models/test.glb';
import glbtest2 from '../models/test2.glb';
import glbtest3 from '../models/test3.glb';

import { useState, useTransition, useEffect } from "react";
import Carousel from 'react-elastic-carousel'
import { NavLink } from "react-router-dom";

import ModelCard from '../components/ModelCard';
import ModelCanvas from '../components/ModelCanvas';


const cardData = [
  {
    id: 1,
    model: glbtest,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 2,
    model: glbtest2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 3,
    model: glbtest3,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 4,
    model: glbtest3,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 5,
    model: glbtest2,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 6,
    model: glbtest,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 7,
    model: glbtest2,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 8,
    model: glbtest,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 9,
    model: glbtest2,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 10,
    model: glbtest3,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 11,
    model: glbtest2,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 12,
    model: glbtest,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
  {
    id: 13,
    model: glbtest3,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'CA2CA3',
  },
  {
    id: 14,
    model: glbtest2,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
  },
];


function Visualizer() {

  const [model, setModel] = useState(glbtest);
  const [loaded, setLoaded] = useState(<ModelCanvas model={glbtest} />)

  const [isPending, startTransition] = useTransition();

  const [titleText, setTitleText] = useState('ROIs: CA1 to CA2CA3')
  const [sideText, setSideText] = useState('Hemisphere: Left')
  const [roi1, setRoi1] = useState('CA1')
  const [roi2, setRoi2] = useState('CA2CA3')

  useEffect(() => {
    setLoaded(<ModelCanvas model={model} />);
  }, [model]);

  return (
    <div className="visualizercontainer">
      <div className='vistop'>
          <div className='infobox'>
            <div className='infolines'>
            <h1>{titleText}</h1>
            <h3>{sideText}</h3>
            <h3>N-Tracts: 724</h3>
            <div className='clabel'>
              <div className='purplebox'></div>
              <h3>{roi1}</h3>
            </div>
            <div className='clabel'>
              <div className='bluebox'></div>
              <h3>{roi2}</h3>
            </div>
          </div>
          <NavLink to='/about'>
            <div className='aboutlink'>
              <h2>ABOUT THE PROJECT</h2>
            </div>
          </NavLink>
          </div>
          {isPending ? <h4>LOADING...</h4> : <></>}
          {loaded}
      </div>
      <div className='visbot'>
        <Carousel itemsToShow={6}>
        {cardData.map((card) =>
          <div key={card.id} onClick={() => {
            startTransition(() => {
              setModel(card.model)
              setTitleText(`ROIs: ${card.firstROI} to ${card.secondROI}`)
              setSideText(`Hemisphere: ${card.side}`)
              setRoi1(card.firstROI)
              setRoi2(card.secondROI)
                })
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