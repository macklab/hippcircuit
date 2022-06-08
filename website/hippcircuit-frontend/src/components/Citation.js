import './Citation.css';

import { useState } from "react";

export default function Citation(props) {

    const [mouseIn, setMouseIn] = useState(false);

  return (
    <>
        <sup>
            <span className="citcontainer"
                onMouseEnter={() => setMouseIn(true)}
                onMouseLeave={() => setMouseIn(false)}>
                {props.text}
            </span>
        </sup>
        {mouseIn && 
            <div className='citbar'>
                <div className='citdiv'
                    onMouseEnter={() => setMouseIn(true)}
                    onMouseLeave={() => setMouseIn(false)}>
                    {props.content.map((data) =>
                            <p>{data}</p>
                    )}
                </div>
            </div>
        }
    </>
  );
}
