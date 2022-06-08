import './ModelCard.css';

export default function ModelCard(props) {

  return (
    <div className='modelcardcontainer'>
        <p>{props.side}</p>
        <p>{props.firstROI}</p>
        <p>to</p>
        <p>{props.secondROI}</p>
    </div>
  );
}
