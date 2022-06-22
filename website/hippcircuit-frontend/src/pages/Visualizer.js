import './Visualizer.css';

import { useState, useTransition, useEffect } from "react";
import Carousel from 'react-elastic-carousel'
import { NavLink } from "react-router-dom";

import ModelCard from '../components/ModelCard';
import ModelCanvas from '../components/ModelCanvas';

import { cardData } from  '../jsondata.js';


function Visualizer() {

  const [model, setModel] = useState(cardData[0].model);
  const [loaded, setLoaded] = useState(<ModelCanvas model={cardData[0].model} />)

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
          <a href='https://docs.google.com/forms/d/e/1FAIpQLSeghEkTcCFaqrCPLIrvBv9x6UaP46KsWoloHfdfSp6v1BkQxw/viewform' style={{textDecoration: 'none'}}>
            <div className='aboutlink'>
              <h2>OTHER DATA & RESULTS</h2>
            </div>
          </a>
          <a href='https://docs.google.com/forms/d/e/1FAIpQLSeghEkTcCFaqrCPLIrvBv9x6UaP46KsWoloHfdfSp6v1BkQxw/viewform' style={{textDecoration: 'none'}}>
            <div className='aboutlink'>
              <h2>ABOUT THE PROJECT</h2>
            </div>
          </a>
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
