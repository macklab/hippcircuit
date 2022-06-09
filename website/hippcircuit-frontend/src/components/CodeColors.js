import './CodeColors.css';


export function GreenComment(props) {

  return (
    <span className='greencomment'>
        {props.text}
    </span>
  );
};


export function YellowCode(props) {

    return (
      <span className='yellowcode'>
          {props.text}
      </span>
    );
  };


export function WhiteCode(props) {

    return (
      <span className='whitecode'>
          {props.text}
      </span>
    );
  };


export function PurpleCode(props) {

    return (
      <span className='purplecode'>
          {props.text}
      </span>
    );
  };


export function DarkBlueCode(props) {

    return (
      <span className='darkbluecode'>
          {props.text}
      </span>
    );
  };

export function LightBlueCode(props) {

    return (
      <span className='lightbluecode'>
          {props.text}
      </span>
    );
  };


export function OrangeCode(props) {

    return (
      <span className='orangecode'>
          {props.text}
      </span>
    );
  };


export function LineBreak() {

    return (
      <br />
    );
  }


export function LineTabShort() {

    return (
      <span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
    );
  }


export function LineTabLong() {

    return (
      <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
    );
  }