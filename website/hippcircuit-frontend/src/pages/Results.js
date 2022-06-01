import './Results.css';

import logo1 from '../images/MackLabLogo.png';
import logo2 from '../images/BuddingMindsLogo.png';
import logo3 from '../images/BrainCanadaLogoDark.png';
import logo4 from '../images/CIHRLogo.jpg';
import logo5 from '../images/NSERC_logo.png';
import logo6 from '../images/Vanier_logo.png';
import logo7 from '../images/blender_logo.png';

import { NavLink } from "react-router-dom";
import { useState } from 'react';
import ROIButton from '../components/ROIButton';

import TestFile from '../downloads/test.zip';


const buttondata = [
    {
        id: 1,
        side: '',
        firstROI: 'All ROIs',
        secondROI: 'all ROIs',
        n: 3390,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for all ROIs'
      },
      {
        id: 2,
        side: 'Left',
        firstROI: 'CA1',
        secondROI: 'SUB',
        n: 283,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left CA1 to SUB'
      },
      {
        id: 3,
        side: 'Left',
        firstROI: 'CA2CA3',
        secondROI: 'CA1',
        n: 44,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left CA2CA3 to CA1'
      },
      {
        id: 4,
        side: 'Left',
        firstROI: 'CA4DG',
        secondROI: 'CA2CA3',
        n: 163,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left CA4DG to CA2CA3'
      },
      {
        id: 5,
        side: 'Left',
        firstROI: 'ERC',
        secondROI: 'CA1',
        n: 128,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left ERC to CA1'
      },
      {
        id: 6,
        side: 'Left',
        firstROI: 'ERC',
        secondROI: 'CA4DG',
        n: 0,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left ERC to CA4DG'
      },
      {
        id: 7,
        side: 'Left',
        firstROI: 'SUB',
        secondROI: 'CA4DG',
        n: 83,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left SUB to CA4DG'
      },
      {
        id: 8,
        side: 'Left',
        firstROI: 'SUB',
        secondROI: 'ERC',
        n: 841,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left SUB to ERC'
      },
      {
        id: 9,
        side: 'Right',
        firstROI: 'CA1',
        secondROI: 'SUB',
        n: 616,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right CA1 to SUB'
      },
      {
        id: 10,
        side: 'Right',
        firstROI: 'CA2CA3',
        secondROI: 'CA1',
        n: 108,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right CA2CA3 to CA1'
      },
      {
        id: 11,
        side: 'Right',
        firstROI: 'CA4DG',
        secondROI: 'CA2CA3',
        n: 301,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right CA4DG to CA2CA3'
      },
      {
        id: 12,
        side: 'Right',
        firstROI: 'ERC',
        secondROI: 'CA1',
        n: 110,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right ERC to CA1'
      },
      {
        id: 13,
        side: 'Right',
        firstROI: 'ERC',
        secondROI: 'CA4DG',
        n: 0,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right ERC to CA4DG'
      },
      {
        id: 14,
        side: 'Right',
        firstROI: 'SUB',
        secondROI: 'CA4DG',
        n: 33,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right SUB to CA4DG'
      },
      {
        id: 15,
        side: 'Right',
        firstROI: 'SUB',
        secondROI: 'ERC',
        n: 680,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right SUB to ERC'
      }
];


function Results() {

  const [roistitle, setRoisTitle] = useState('All ROIs to All ROIs');
  const [downloadFile, setDownloadFile] = useState(TestFile);
  const [downloadName, setDownloadName] = useState('Testfile.zip');
  const [downloadText, setDownloadText] = useState('Download data for all ROIs');

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
                    }}>
                        <ROIButton key={button.id} name={`${button.side} ${button.firstROI} to ${button.secondROI}`} />
                    </div>
                )}
            </div>
        </div>
        <div className='resspacerbar'></div>
        <div className='roititlerow'>
          <h2>{roistitle}</h2>
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
            <img src={logo7} alt="Test1" />
            <h4>{"A caption for image 1."}</h4>
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