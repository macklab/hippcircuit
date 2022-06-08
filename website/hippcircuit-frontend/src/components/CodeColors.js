import './CodeColors.css';


export function GreenComment(props) {

  return (
    <span className='greencomment'>
        <p>{props.text}</p>
    </span>
  );
};


export function YellowCode(props) {

    return (
      <span className='yellowcode'>
          <p>{props.text}</p>
      </span>
    );
  };


export function WhiteCode(props) {

    return (
      <span className='whitecode'>
          <p>{props.text}</p>
      </span>
    );
  };