import './Home.css';

import { useNavigate } from "react-router-dom";

import logo from '../images/MackLabLogo.png';
import ilf from '../images/ILF.png';
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
            <a href='http://macklab.utoronto.ca/'><img src={logo} alt='The Mack Lab logo!'/></a>
        </div>
        <div className="hleft">
            <img src={ilf} alt='The inferior longitudinal fasciculus.'/>
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