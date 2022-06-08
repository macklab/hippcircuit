import './CodeComponents.css';


export function CodeTitle(props) {

  return (
    <div className="coderowcontainer">
        <div className='codeleftcolumn'>
            <h1>{props.text}</h1>
        </div>
        <div className='coderightcolumn'>
            
        </div>
    </div>
  );
};


export function CodeSpacer() {

    return (
      <div className="coderowcontainer">
          <div className='codeleftcolumn'>
              <div className='codespacediv'></div>
          </div>
          <div className='coderightcolumn'>
            <div className='codespacediv'></div>
          </div>
      </div>
    );
  };


  export function CodeBlock(props) {

    return (
      <div className="coderowcontainer">
          <div className='codeleftcolumn'>
            {props.descriptions.map((paragraph) =>
                <p>{paragraph}</p>
            )}
          </div>
          <div className='coderightcolumn'>
                {props.codelines.map((line) => {
                    return <p>{line}</p>
                })}
          </div>
      </div>
    );
  };