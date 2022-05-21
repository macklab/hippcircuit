import './Results.css';

import logo1 from '../images/MackLabLogo.png';
import logo2 from '../images/BuddingMindsLogo.png';
import logo3 from '../images/BrainCanadaLogoDark.png';
import logo4 from '../images/CIHRLogo.jpg';

import { NavLink } from "react-router-dom";
import ROIButton from '../components/ROIButton';


const buttondata = [
    {
        id: 1,
        side: '',
        firstROI: 'All ROIs',
        secondROI: 'all ROIs',
        n: 3390
      },
      {
        id: 2,
        side: 'Left',
        firstROI: 'CA1',
        secondROI: 'SUB',
        n: 283
      },
      {
        id: 3,
        side: 'Left',
        firstROI: 'CA2CA3',
        secondROI: 'CA1',
        n: 44
      },
      {
        id: 4,
        side: 'Left',
        firstROI: 'CA4DG',
        secondROI: 'CA2CA3',
        n: 163
      },
      {
        id: 5,
        side: 'Left',
        firstROI: 'ERC',
        secondROI: 'CA1',
        n: 128
      },
      {
        id: 6,
        side: 'Left',
        firstROI: 'ERC',
        secondROI: 'CA4DG',
        n: 0
      },
      {
        id: 7,
        side: 'Left',
        firstROI: 'SUB',
        secondROI: 'CA4DG',
        n: 83
      },
      {
        id: 8,
        side: 'Left',
        firstROI: 'SUB',
        secondROI: 'ERC',
        n: 841
      },
      {
        id: 9,
        side: 'Right',
        firstROI: 'CA1',
        secondROI: 'SUB',
        n: 616
      },
      {
        id: 10,
        side: 'Right',
        firstROI: 'CA2CA3',
        secondROI: 'CA1',
        n: 108
      },
      {
        id: 11,
        side: 'Right',
        firstROI: 'CA4DG',
        secondROI: 'CA2CA3',
        n: 301
      },
      {
        id: 12,
        side: 'Right',
        firstROI: 'ERC',
        secondROI: 'CA1',
        n: 110
      },
      {
        id: 13,
        side: 'Right',
        firstROI: 'ERC',
        secondROI: 'CA4DG',
        n: 0
      },
      {
        id: 14,
        side: 'Right',
        firstROI: 'SUB',
        secondROI: 'CA4DG',
        n: 33
      },
      {
        id: 15,
        side: 'Right',
        firstROI: 'SUB',
        secondROI: 'ERC',
        n: 680
      }
];


function Results() {
  return (
    <div className="resultscontainer">
      <div className='resultsheader'>
          <div className='backbutton'>
            <NavLink to='/explore'>
                <h2>{'<'} BACK</h2>
            </NavLink>
          </div>
      </div>
      <div className='resultsbody'>
        <div className='buttonbar'>
            <div className='buttoncollection'>
                {buttondata.map((button) =>
                    <div className='buttonflexitem'>
                        <ROIButton key={button.id} name={`${button.side} ${button.firstROI} to ${button.secondROI}`} />
                    </div>
                )}
            </div>
        </div>
      </div>
      <div className='resultsfooter'>
        <a href='http://macklab.utoronto.ca/'><img className='resultslogo' alt='The Mack Lab logo!' src={logo1} /></a>
        <a href='http://buddingmindslab.utoronto.ca/'><img className='resultslogo' alt='The Budding Minds Lab logo!' src={logo2} /></a>
        <a href='https://braincanada.ca/'><img className='resultslogo' alt='The Brain Canada logo!' src={logo3} /></a>
        <a href='https://cihr-irsc.gc.ca/e/193.html'><img className='resultslogo' alt='The CIHR logo!' src={logo4} /></a>
      </div>
    </div>
  );
}

export default Results;