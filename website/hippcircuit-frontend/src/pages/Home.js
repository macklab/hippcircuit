import './Home.css';

import { NavLink } from "react-router-dom";

import logo from '../images/MackLabLogo.png';
import ilf from '../images/ILF.png';
import HomeButton from '../components/HomeButton';

function Home() {
  return (
    <div className="container">
        <div className="top">
            <a href='http://macklab.utoronto.ca/'><img src={logo} alt='The Mack Lab logo!'/></a>
        </div>
        <div className="left">
            <img src={ilf} alt='The inferior longitudinal fasciculus.'/>
        </div>
        <div className="right">
            <h1>HippCircuit</h1>
            <div className='enterButton'>
                <NavLink to="/about">
                    <HomeButton />
                </NavLink>
            </div>
        </div>
    </div>
  );
}

export default Home;