import './Visualizer.css';

import glbtest from '../models/test.glb';
import glbtest2 from '../models/test2.glb';
import glbtest3 from '../models/test3.glb';

import LCA1SUB from '../models/L_CA1_SUB.glb';
import LCA2CA3CA1 from '../models/L_CA2CA3_CA1.glb';
import LCA4DGCA2CA3 from '../models/L_CA4DG_CA2CA3.glb';
import LERCCA1 from '../models/L_ERC_CA1.glb';
import LERCCA4DG from '../models/L_ERC_CA4DG.glb';
import LSUBCA4DG from '../models/L_SUB_CA4DG.glb';
import LSUBERC from '../models/L_SUB_ERC.glb';

import { useState, useTransition, useEffect } from "react";
import Carousel from 'react-elastic-carousel'
import { NavLink } from "react-router-dom";

import ModelCard from '../components/ModelCard';
import ModelCanvas from '../components/ModelCanvas';


const cardData = [
  {
    id: 1,
    model: LCA1SUB,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'SUB',
    n: 283
  },
  {
    id: 2,
    model: LCA2CA3CA1,
    side: 'Left',
    firstROI: 'CA2CA3',
    secondROI: 'CA1',
    n: 44
  },
  {
    id: 3,
    model: LCA4DGCA2CA3,
    side: 'Left',
    firstROI: 'CA4DG',
    secondROI: 'CA2CA3',
    n: 163
  },
  {
    id: 4,
    model: LERCCA1,
    side: 'Left',
    firstROI: 'ERC',
    secondROI: 'CA1',
    n: 128
  },
  {
    id: 5,
    model: LERCCA4DG,
    side: 'Left',
    firstROI: 'ERC',
    secondROI: 'CA4DG',
    n: 0
  },
  {
    id: 6,
    model: LSUBCA4DG,
    side: 'Left',
    firstROI: 'SUB',
    secondROI: 'CA4DG',
    n: 83
  },
  {
    id: 7,
    model: LSUBERC,
    side: 'Left',
    firstROI: 'SUB',
    secondROI: 'ERC',
    n: 841
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

  const [model, setModel] = useState(LCA1SUB);
  const [loaded, setLoaded] = useState(<ModelCanvas model={LCA1SUB} />)

  const [isPending, startTransition] = useTransition();

  const [titleText, setTitleText] = useState('ROIs: CA1 to SUB')
  const [sideText, setSideText] = useState('Hemisphere: Left')
  const [roi1, setRoi1] = useState('CA1')
  const [roi2, setRoi2] = useState('SUB')
  const [n, setN] = useState(283)

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
            <h3>Number of tracts: {n}</h3>
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
              setN(card.n)
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