import './Visualizer.css';

import ALLTRACTS from '../models/Full_Model.glb';
import LCA1SUB from '../models/L_CA1_SUB.glb';
import LCA2CA3CA1 from '../models/L_CA2CA3_CA1.glb';
import LCA4DGCA2CA3 from '../models/L_CA4DG_CA2CA3.glb';
import LERCCA1 from '../models/L_ERC_CA1.glb';
import LERCCA4DG from '../models/L_ERC_CA4DG.glb';
import LSUBCA4DG from '../models/L_SUB_CA4DG.glb';
import LSUBERC from '../models/L_SUB_ERC.glb';
import RCA1SUB from '../models/R_CA1_SUB.glb';
import RCA2CA3CA1 from '../models/R_CA2CA3_CA1.glb';
import RCA4DGCA2CA3 from '../models/R_CA4DG_CA2CA3.glb';
import RERCCA1 from '../models/R_ERC_CA1.glb';
import RERCCA4DG from '../models/R_ERC_CA4DG.glb';
import RSUBCA4DG from '../models/R_SUB_CA4DG.glb';
import RSUBERC from '../models/R_SUB_ERC.glb'

import { useState, useTransition, useEffect } from "react";
import Carousel from 'react-elastic-carousel'
import { NavLink } from "react-router-dom";

import ModelCard from '../components/ModelCard';
import ModelCanvas from '../components/ModelCanvas';


const cardData = [
  {
    id: 1,
    model: ALLTRACTS,
    side: 'Both',
    firstROI: 'All ROIs',
    secondROI: 'all ROIs',
    n: 3390
  },
  {
    id: 2,
    model: LCA1SUB,
    side: 'Left',
    firstROI: 'CA1',
    secondROI: 'SUB',
    n: 283
  },
  {
    id: 3,
    model: LCA2CA3CA1,
    side: 'Left',
    firstROI: 'CA2CA3',
    secondROI: 'CA1',
    n: 44
  },
  {
    id: 4,
    model: LCA4DGCA2CA3,
    side: 'Left',
    firstROI: 'CA4DG',
    secondROI: 'CA2CA3',
    n: 163
  },
  {
    id: 5,
    model: LERCCA1,
    side: 'Left',
    firstROI: 'ERC',
    secondROI: 'CA1',
    n: 128
  },
  {
    id: 6,
    model: LERCCA4DG,
    side: 'Left',
    firstROI: 'ERC',
    secondROI: 'CA4DG',
    n: 0
  },
  {
    id: 7,
    model: LSUBCA4DG,
    side: 'Left',
    firstROI: 'SUB',
    secondROI: 'CA4DG',
    n: 83
  },
  {
    id: 8,
    model: LSUBERC,
    side: 'Left',
    firstROI: 'SUB',
    secondROI: 'ERC',
    n: 841
  },
  {
    id: 9,
    model: RCA1SUB,
    side: 'Right',
    firstROI: 'CA1',
    secondROI: 'SUB',
    n: 616
  },
  {
    id: 10,
    model: RCA2CA3CA1,
    side: 'Right',
    firstROI: 'CA2CA3',
    secondROI: 'CA1',
    n: 108
  },
  {
    id: 11,
    model: RCA4DGCA2CA3,
    side: 'Right',
    firstROI: 'CA4DG',
    secondROI: 'CA2CA3',
    n: 301
  },
  {
    id: 12,
    model: RERCCA1,
    side: 'Right',
    firstROI: 'ERC',
    secondROI: 'CA1',
    n: 110
  },
  {
    id: 13,
    model: RERCCA4DG,
    side: 'Right',
    firstROI: 'ERC',
    secondROI: 'CA4DG',
    n: 0
  },
  {
    id: 14,
    model: RSUBCA4DG,
    side: 'Right',
    firstROI: 'SUB',
    secondROI: 'CA4DG',
    n: 33
  },
  {
    id: 15,
    model: RSUBERC,
    side: 'Right',
    firstROI: 'SUB',
    secondROI: 'ERC',
    n: 680
  },
];


function Visualizer() {

  const [model, setModel] = useState(ALLTRACTS);
  const [loaded, setLoaded] = useState(<ModelCanvas model={ALLTRACTS} />)

  const [isPending, startTransition] = useTransition();

  const [titleText, setTitleText] = useState('All tracts and ROIs')
  const [sideText, setSideText] = useState('Both hemishperes')
  const [roi1, setRoi1] = useState('N/A')
  const [roi2, setRoi2] = useState('N/A')
  const [n, setN] = useState(3390)

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
          <NavLink to='/results'>
            <div className='aboutlink'>
              <h2>OTHER DATA & RESULTS</h2>
            </div>
          </NavLink>
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