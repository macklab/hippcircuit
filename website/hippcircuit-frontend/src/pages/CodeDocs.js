import './CodeDocs.css';

import { CodeTitle, CodeSpacer, CodeBlock } from '../components/CodeComponents';
import { GreenComment, WhiteCode, YellowCode } from '../components/CodeColors';


function CodeDocs() {

  return (
    <div className="codedocscontainer">
        <CodeTitle text='Documentation' />
        <CodeSpacer />
        <CodeBlock descriptions={['Hey there!']} codelines={[<GreenComment text='// This is a comment' />]} />
        <CodeBlock descriptions={['']} codelines={[<YellowCode text='functionDef' />, <WhiteCode text="( )" />]} />
    </div>
  );
}

export default CodeDocs;