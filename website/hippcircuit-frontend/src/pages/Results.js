import './Results.css';

import { logo1, logo2, logo3, logo4, logo5, logo6, logo7 } from '../jsondata.js';

import { NavLink } from "react-router-dom";
import { useState } from 'react';
import ROIButton from '../components/ROIButton';

import { buttondata } from '../jsondata.js';


function Results() {

  const [roisTitle, setRoisTitle] = useState('All ROIs to All ROIs');
  const [downloadFile, setDownloadFile] = useState(buttondata[0].downloadFile);
  const [downloadName, setDownloadName] = useState('Testfile.zip');
  const [downloadText, setDownloadText] = useState('Download data for all ROIs');
  const [streamViolinPlot, setStreamViolinPlot] = useState(null);

  return (
    <div className="resultscontainer">
      <div className='resultsheader'>
        <NavLink to='/explore'>
          <div className='backbutton'>
            <h2>{'<'} BACK</h2>
          </div>
        </NavLink>
        <h1>Results and Data Download</h1>
      </div>
      <div className='resultsbody'>
        <div className='resspacerbar'></div>
        <div className='buttonbar'>
            <div className='buttoncollection'>
                {buttondata.map((button) =>
                    <div className='buttonflexitem' onClick={() => {
                      setRoisTitle(`${button.side} ${button.firstROI} to ${button.secondROI}`)
                      setDownloadFile(button.downloadFile)
                      setDownloadName(button.downloadName)
                      setDownloadText(button.downloadText)
                      setStreamViolinPlot(button.streamsViolin)
                    }}>
                        <ROIButton key={button.id} name={`${button.side} ${button.firstROI} to ${button.secondROI}`} />
                    </div>
                )}
            </div>
        </div>
        <div className='resspacerbar'></div>
        <div className='roititlerow'>
          <h2>{roisTitle}</h2>
        </div>
        <div className='downloadrow'>
          <a href={downloadFile} download={downloadName}>
            <div className='downloadbutton'>
              <p>{downloadText}</p>
            </div>
          </a>
        </div>
        <div className='dataviews'>
          <div className='topleftdata'>
            {(streamViolinPlot != null) ? <img src={streamViolinPlot} alt="Streams violin plot." /> : <h3>No streams violin plot for this data.</h3>}
            <h4>Streamline counts violin plot for {roisTitle}.</h4>
          </div>
          <div className='toprightdata'>
            <img src={logo7} alt="Test2" />
            <h4>{"A caption for image 2."}</h4>
          </div>
          <div className='botleftdata'>
            <img src={logo7} alt="Test3" />
            <h4>{"A caption for image 3."}</h4>
          </div>
          <div className='botrightdata'>
            <img src={logo7} alt="Test4" />
            <h4>{"A caption for image 4."}</h4>
          </div>
        </div>
      </div>
      <div className='resspacerbar'></div>
      <div className='resultsfooter'>
        <a href='http://macklab.utoronto.ca/'><img className='resultslogo' alt='The Mack Lab logo!' src={logo1} /></a>
        <a href='http://buddingmindslab.utoronto.ca/'><img className='resultslogo' alt='The Budding Minds Lab logo!' src={logo2} /></a>
        <a href='https://braincanada.ca/'><img className='resultslogo' alt='The Brain Canada logo!' src={logo3} /></a>
        <a href='https://cihr-irsc.gc.ca/e/193.html'><img className='resultslogo' alt='The CIHR logo!' src={logo4} /></a>
        <a href='https://www.nserc-crsng.gc.ca/index_eng.asp'><img className='resultslogo' alt='The NSERC logo!' src={logo5} /></a>
        <a href='https://vanier.gc.ca/en/home-accueil.html'><img className='resultslogo' alt='The Vanier logo!' src={logo6} /></a>
        <a href='https://www.blender.org/'><img className='resultslogo' alt='The Blender logo!' src={logo7} /></a>
      </div>
    </div>
  );
}

export default Results;
