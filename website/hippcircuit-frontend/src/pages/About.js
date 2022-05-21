import './About.css';

import tractrotate from '../images/homegif.gif';
import pipeline from '../images/pipeline.png';
import logo1 from '../images/MackLabLogo.png';
import logo2 from '../images/BuddingMindsLogo.png';
import logo3 from '../images/BrainCanadaLogoDark.png';
import logo4 from '../images/CIHRLogo.jpg';

import { NavLink } from "react-router-dom";

function About() {
  return (
    <div className="aboutcontainer">
      <div className='atitle'>
        <h1>About the HippCircuit project:</h1>
        <NavLink to='/explore'>
          <h4>{'<'} BACK TO THE DATA</h4>
        </NavLink>
      </div>
      <div className='whiteblockright'>
        <div className='wleft'>
            <h2>What we are doing:</h2>
            <p>Donec eu velit eget dui congue elementum. In at nisl massa. Pellentesque mollis, elit quis vestibulum auctor, metus justo eleifend urna, quis bibendum tortor odio ac dui. Aliquam lobortis ipsum id dui bibendum, et mollis leo lobortis. Aliquam condimentum accumsan lacus. Nullam sodales dictum purus at luctus. Aliquam eleifend at dui quis pulvinar. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam ultrices cursus velit at egestas. Pellentesque gravida mollis elementum.</p>
            <p>Aenean a nunc est. Proin consectetur velit quis ligula venenatis egestas. Aliquam efficitur ligula urna, eu posuere libero tristique sed. Ut quis lorem in dui euismod varius. Sed iaculis nunc at mi tincidunt ornare. Etiam feugiat dignissim consectetur. Cras at mauris porttitor magna molestie facilisis nec eget magna. Praesent aliquam facilisis mauris, sit amet interdum eros finibus nec. Suspendisse ut aliquet libero, ac volutpat urna. Donec sollicitudin nisi et eros dignissim, nec facilisis sapien consectetur. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nullam id elementum nibh. Aliquam sed euismod sem. Nulla urna velit, suscipit eget feugiat ac, lobortis porttitor sem.</p>
        </div>
        <div className='wright'>
          <img src={tractrotate} alt='The inferior longitudinal fasciculus.'/>
        </div>
      </div>

      <div className='blueblockleft'>
        <div className='bleft'>
          <img src={pipeline} alt='The inferior longitudinal fasciculus.'/>
        </div>
        <div className='bright'>
            <h2>The pipeline:</h2>
            <p>Donec eu velit eget dui congue elementum. In at nisl massa. Pellentesque mollis, elit quis vestibulum auctor, metus justo eleifend urna, quis bibendum tortor odio ac dui. Aliquam lobortis ipsum id dui bibendum, et mollis leo lobortis. Aliquam condimentum accumsan lacus. Nullam sodales dictum purus at luctus. Aliquam eleifend at dui quis pulvinar. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam ultrices cursus velit at egestas. Pellentesque gravida mollis elementum.</p>
            <p>Aenean a nunc est. Proin consectetur velit quis ligula venenatis egestas. Aliquam efficitur ligula urna, eu posuere libero tristique sed. Ut quis lorem in dui euismod varius. Sed iaculis nunc at mi tincidunt ornare. Etiam feugiat dignissim consectetur. Cras at mauris porttitor magna molestie facilisis nec eget magna. Praesent aliquam facilisis mauris, sit amet interdum eros finibus nec. Suspendisse ut aliquet libero, ac volutpat urna. Donec sollicitudin nisi et eros dignissim, nec facilisis sapien consectetur. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nullam id elementum nibh. Aliquam sed euismod sem. Nulla urna velit, suscipit eget feugiat ac, lobortis porttitor sem.</p>
        </div>
      </div>
      <div className='alogo'>
            <div className='supporttitle'>
              <h1>This project was made possible with funding and support from:</h1>
            </div>
            <div className='supportlogos'>
              <a href='http://macklab.utoronto.ca/'><img className='resultslogo' alt='The Mack Lab logo!' src={logo1} /></a>
              <a href='http://buddingmindslab.utoronto.ca/'><img className='resultslogo' alt='The Budding Minds Lab logo!' src={logo2} /></a>
              <a href='https://braincanada.ca/'><img className='resultslogo' alt='The Brain Canada logo!' src={logo3} /></a>
              <a href='https://cihr-irsc.gc.ca/e/193.html'><img className='resultslogo' alt='The CIHR logo!' src={logo4} /></a>
              </div>
      </div>
    </div>
  );
}

export default About;