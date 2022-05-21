import './Home.css';

import { useNavigate } from "react-router-dom";

import logo1 from '../images/MackLabLogo.png';
import logo2 from '../images/BuddingMindsLogo.png';
import logo3 from '../images/BrainCanadaLogoDark.png';
import logo4 from '../images/CIHRLogo.jpg';

import tractrotate from '../images/homegif.gif';
import HomeButton from '../components/HomeButton';

function Home() {

    const navigate = useNavigate();

    function handleClick() {
        navigate("/explore");
        window.location.reload(false);
    }

  return (
    <div className="container">
        <div className="top">
            <a href='http://macklab.utoronto.ca/'><img className='resultslogo' alt='The Mack Lab logo!' src={logo1} /></a>
            <a href='http://buddingmindslab.utoronto.ca/'><img className='resultslogo' alt='The Budding Minds Lab logo!' src={logo2} /></a>
            <a href='https://braincanada.ca/'><img className='resultslogo' alt='The Brain Canada logo!' src={logo3} /></a>
            <a href='https://cihr-irsc.gc.ca/e/193.html'><img className='resultslogo' alt='The CIHR logo!' src={logo4} /></a>
        </div>
        <div className="hleft">
            <img src={tractrotate} alt='Rotating HippCircuit tractography!'/>
        </div>
        <div className="hright">
            <h1>HippCircuit</h1>
            <div className='enterButton' onClick={() => handleClick()}>
                <HomeButton />
            </div>
        </div>
    </div>
  );
}

export default Home;