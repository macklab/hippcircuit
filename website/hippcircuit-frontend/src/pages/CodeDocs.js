import './CodeDocs.css';

import { CodeTitle, CodeSpacer, CodeBlock } from '../components/CodeComponents';

import { GreenComment, 
         WhiteCode, 
         YellowCode, 
         DarkBlueCode, 
         LightBlueCode, 
         PurpleCode, 
         LineBreak, 
         LineTabShort,
         LineTabLong, 
         OrangeCode} from '../components/CodeColors';


function CodeDocs() {

  return (
    <div className="codedocscontainer">
        <CodeTitle text='Documentation' />
        <CodeSpacer />
        <CodeBlock descriptions={['This is an example script to show the way a docs page could work.']} codelines={[]} />
        <CodeSpacer />
        <CodeBlock descriptions={['Starting the script with configuration.']} codelines={[<LineTabShort />, 
                                                                                          <GreenComment text='# Setting BIDS directory' />]} />
        <CodeBlock descriptions={[]} codelines={[<LineTabShort />, 
                                                 <LightBlueCode text='bids_dir' />, 
                                                 <WhiteCode text=' = ' />, 
                                                 <OrangeCode text='"/project/m/mmack/projects/hippcircuit"' />]} />
        <CodeBlock descriptions={[]} codelines={[<LineBreak />,
                                                 <LineTabShort />, 
                                                 <GreenComment text='# Importing packages' />]} />
        <CodeBlock descriptions={[]} codelines={[<LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='NiaEnv/2018a' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='intel/2018.2' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='ants/2.3.1' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='openblas/0.2.20' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='fsl/.experimental-6.0.0' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='fftw/3.3.7' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='eigen/3.3.4' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='mrtrix/3.0.0' />,
                                                 <LineBreak />,
                                                 <LineTabShort />, 
                                                 <PurpleCode text='module' />, 
                                                 <YellowCode text=' load ' />, 
                                                 <WhiteCode text='freesurfer/6.0.0' />,
                                                 <LineBreak />,
                                                 <LineBreak />]} />
        <CodeBlock descriptions={['Defining subject numbers']} codelines={[<LineTabShort />,
                                                                           <GreenComment text='# Define subjects for analysis' />,
                                                                           <LineBreak />,
                                                                           <LineBreak />,
                                                                           <LineTabShort />,
                                                                           <LightBlueCode text='sbjs' />,
                                                                           <WhiteCode text=' = ' />,
                                                                           <DarkBlueCode text='$' />,
                                                                           <DarkBlueCode text='(' />,
                                                                           <PurpleCode text='sed ' />,
                                                                           <WhiteCode text='-n ' />,
                                                                           <LightBlueCode text='1' />,
                                                                           <WhiteCode text=',' />,
                                                                           <LightBlueCode text='831p ' />,
                                                                           <DarkBlueCode text='${' />,
                                                                           <LightBlueCode text='bids_dir' />,
                                                                           <DarkBlueCode text='}' />,
                                                                           <OrangeCode text='/derivatives/subjects/final_subjects.txt' />,
                                                                           <DarkBlueCode text=')' />, 
                                                                           <LineBreak />,
                                                                           <LineBreak />]} />
        <CodeBlock descriptions={['Creating subject folders']} codelines={[<LineTabShort />,
                                                                           <GreenComment text='# Create subject specific folders for FBA' />,
                                                                           <LineBreak />,
                                                                           <LineBreak />,
                                                                           <LineTabShort />,
                                                                           <PurpleCode text='mkdir ' />,
                                                                           <DarkBlueCode text='${' />,
                                                                           <LightBlueCode text='bids_dir' />,
                                                                           <DarkBlueCode text='}' />,
                                                                           <OrangeCode text='/derivatives/fixel-based/fixels' />,
                                                                           <LineBreak />,
                                                                           <LineTabShort />,
                                                                           <YellowCode text='for ' />,
                                                                           <LightBlueCode text='i ' />,
                                                                           <YellowCode text='in ' />,
                                                                           <DarkBlueCode text='${' />,
                                                                           <LightBlueCode text='sbjs' />,
                                                                           <DarkBlueCode text='}' />,
                                                                           <WhiteCode text='; ' />,
                                                                           <YellowCode text='do' />,
                                                                           <LineBreak />,
                                                                           <LineTabLong />,
                                                                           <PurpleCode text='mkdir ' />,
                                                                           <DarkBlueCode text='${' />,
                                                                           <LightBlueCode text='bids_dir' />,
                                                                           <DarkBlueCode text='}' />,
                                                                           <OrangeCode text='/derivatives/fixel-based/fixels/sub-' />,
                                                                           <DarkBlueCode text='${' />,
                                                                           <LightBlueCode text='i' />,
                                                                           <DarkBlueCode text='}' />,
                                                                           <LineBreak />,
                                                                           <LineTabShort />,
                                                                           <YellowCode text='done' />,
                                                                           <LineBreak />,
                                                                           <LineBreak />
                                                                           ]} />
        <CodeBlock descriptions={['Generating brain mask images']} codelines={[<LineTabShort />,
                                                                               <GreenComment text='# 1) Compute brain mask images' />,
                                                                               <LineBreak />,
                                                                               <LineBreak />,
                                                                               <LineTabShort />,
                                                                               <YellowCode text='for ' />,
                                                                               <LightBlueCode text='i ' />,
                                                                               <YellowCode text='in ' />,
                                                                               <DarkBlueCode text='${' />,
                                                                               <LightBlueCode text='sbjs' />,
                                                                               <DarkBlueCode text='}' />,
                                                                               <WhiteCode text='; ' />,
                                                                               <YellowCode text='do' />,
                                                                               <LineBreak />,
                                                                               <LineTabLong />,
                                                                               <PurpleCode text='dwi2mask ' />,
                                                                               <DarkBlueCode text='${' />,
                                                                               <LightBlueCode text='bids_dir' />,
                                                                               <DarkBlueCode text='}' />,
                                                                               <OrangeCode text='/derivatives/mrtrix/sub-' />,
                                                                               <DarkBlueCode text='${' />,
                                                                               <LightBlueCode text='i' />,
                                                                               <DarkBlueCode text='}' />,
                                                                               <OrangeCode text='/DWI.mif ' />,
                                                                               <PurpleCode text='\' />,
                                                                               <LineBreak />,
                                                                               <LineTabLong />,
                                                                               <DarkBlueCode text='${' />,
                                                                               <LightBlueCode text='bids_dir' />,
                                                                               <DarkBlueCode text='}' />,
                                                                               <OrangeCode text='/derivatives/fixel-based/fixels/sub-' />,
                                                                               <DarkBlueCode text='${' />,
                                                                               <LightBlueCode text='i' />,
                                                                               <DarkBlueCode text='}' />,
                                                                               <OrangeCode text='/mask.mif' />,
                                                                               <LineBreak />,
                                                                               <LineTabShort />,
                                                                               <YellowCode text='done' />,
                                                                               <LineBreak />,
                                                                               <LineBreak />
                                                                              ]} />
        <CodeBlock descriptions={['Joint bias field correction and global intensity normalisation']} codelines={[<LineTabShort />,
                                                                                                                 <GreenComment text='# 2) Joint bias field correction and global intensity normalisation' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabShort />,
                                                                                                                 <YellowCode text='for ' />,
                                                                                                                 <LightBlueCode text='i ' />,
                                                                                                                 <YellowCode text='in ' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='sbjs' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <WhiteCode text='; ' />,
                                                                                                                 <YellowCode text='do' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <PurpleCode text='mtnormalise ' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/mrtrix/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/WM_FODs.mif ' />,
                                                                                                                 <PurpleCode text='\' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/fixel-based/fixels/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/WM_FODs_norm.mif ' />,
                                                                                                                 <PurpleCode text='\' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/mrtrix/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/GM.mif ' />,
                                                                                                                 <PurpleCode text='\' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/fixel-based/fixels/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/GM_norm.mif ' />,
                                                                                                                 <PurpleCode text='\' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/mrtrix/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/CSF.mif ' />,
                                                                                                                 <PurpleCode text='\' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/fixel-based/fixels/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/CSF_norm.mif ' />,
                                                                                                                 <PurpleCode text='\' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabLong />,
                                                                                                                 <WhiteCode text='-mask ' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='bids_dir' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/derivatives/fixel-based/fixels/sub-' />,
                                                                                                                 <DarkBlueCode text='${' />,
                                                                                                                 <LightBlueCode text='i' />,
                                                                                                                 <DarkBlueCode text='}' />,
                                                                                                                 <OrangeCode text='/mask.mif' />,
                                                                                                                 <LineBreak />,
                                                                                                                 <LineTabShort />,
                                                                                                                 <YellowCode text='done' />
                                                                                                                ]} />
        <CodeSpacer />
    </div>
  );
}

export default CodeDocs;