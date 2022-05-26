import './About.css';

import tractrotate from '../images/homegif.gif';
import pipeline from '../images/pipeline.png';
import logo1 from '../images/MackLabLogo.png';
import logo2 from '../images/BuddingMindsLogo.png';
import logo3 from '../images/BrainCanadaLogoDark.png';
import logo4 from '../images/CIHRLogo.jpg';
import logo5 from '../images/NSERC_logo.png';
import logo6 from '../images/Vanier_logo.png';

import posterPDF from '../images/OHBM_2022_poster.pdf';

import { NavLink } from "react-router-dom";
import { Document, Page, pdfjs } from "react-pdf";

import Citation from '../components/Citation';

pdfjs.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.js`;


function About() {
  return (
    <div className="aboutcontainer">
      <div className='atitle'>
        <h1>About the HippCircuit project:</h1>
        <NavLink to='/explore'>
          <h4>{'<'} BACK TO THE DATA</h4>
        </NavLink>
      </div>
      <div className='whiteblockright'>
        <div className='wleft'>
            <h2>What we are doing:</h2>
            <p>The hippocampus (HPC) is a key structure in learning and memory. <Citation text="[1]" content={["1. Mack, M. L., Love, B. C., & Preston, A. R. (2018). Building concepts one episode at a time: The hippocampus and concept formation. Neuroscience Letters, 680, 31–38."]}/> ​The function of distinct, anatomically-defined subfields of the HPC have been studied extensively.<Citation text="[2]" content={["2. Duncan, K., Ketz, N., Inati, S. J., & Davachi, L. (2012). Evidence for area CA1 as a match/mismatch detector: A high-resolution fMRI study of the human hippocampus. Hippocampus, 22(3), 389–398."]} /> Yet, it remains unclear these subfields are connected through intrinsic white matter fibers to allow information flow within HPC.</p>
​            <p>Recent studies have begun characterizing broader HPC connections with cortical and subcortical regions with diffusion-weighted MRI.<Citation text="[3,4]" content={["3. Huang, C.-C., Rolls, E. T., Hsu, C.-C. H., Feng, J., & Lin, C.-P. (2021). Extensive Cortical Connectivity of the Human Hippocampal Memory System: Beyond the “What” and “Where” Dual Stream Model. Cerebral Cortex, bhab113.", "4. Maller, J. J., Welton, T., Middione, M., Callaghan, F. M., Rosenfeld, J. V., & Grieve, S. M. (2019). Revealing the Hippocampal Connectome through Super-Resolution 1150-Direction Diffusion MRI. Scientific Reports, 9(1), 2418​"]}/>​</p>
            <p>The goal of the HippCircuit project is to quantify white matter pathways in the human hippocampus and ​in the entorhinal cortex (ERC), to deepen our understanding of HPC/ERC circuitry. We also aim to compare these results to existing theoretical and experimental models of HPC/ERC connectivity and circuitry.​</p>
            <p>This website serves as an interactive data visualizer for 3D models of ROI pairs and their tractography. The website also includes other ROI pair data, including connectivity matrices and FA distributions.</p>
        </div>
        <div className='wright'>
          <img src={tractrotate} alt='The inferior longitudinal fasciculus.'/>
        </div>
      </div>
      <div className='postersection'>
        <div>
          <h2>HippCircuit Poster from <span><a href="https://www.humanbrainmapping.org/i4a/pages/index.cfm?pageid=1">OHBM</a></span> (2022)</h2>
        <Document file={posterPDF}>
          <Page width={1000} pageNumber={1} />
        </Document>
        </div>
      </div>
      <div className='blueblockleft'>
        <div className='bleft'>
          <img src={pipeline} alt='The inferior longitudinal fasciculus.'/>
        </div>
        <div className='bright'>
            <h2>The pipeline:</h2>
            <p>The HippCircuit pipeline was run using 831 (n = 831) young, healthy adults from the Human Connectome Project (HCP).<Citation text="[5]" content={["5. Van Essen, D. C., Smith, S. M., Barch, D. M., Behrens, T. E. J., Yacoub, E., Ugurbil, K., & WU-Minn HCP Consortium. (2013). The WU-Minn Human Connectome Project: An overview. NeuroImage, 80, 62–79."]}/> For all subjects, T1 images with voxel resolution (0.7mm x 0.7mm x 0.7mm) and diffusion images with voxel resolution (1.25mm x 1.25mm x 1.25mm) were preprocessed by the HCP.<Citation text="[5]" content={["5. Van Essen, D. C., Smith, S. M., Barch, D. M., Behrens, T. E. J., Yacoub, E., Ugurbil, K., & WU-Minn HCP Consortium. (2013). The WU-Minn Human Connectome Project: An overview. NeuroImage, 80, 62–79."]}/> Hippocampal subfield segmentation was performed on all participants using MAGeTBrain.<Citation text="[6]" content={["6. Pipitone, J., Park, M. T. M., Winterburn, J., Lett, T. A., Lerch, J. P., Pruessner, J. C., Lepage, M., Voineskos, A. N., Chakravarty, M. M., & Alzheimer’s Disease Neuroimaging Initiative.(2014). Multi-atlas segmentation of the whole hippocampus and subfields using multiple automatically generated templates. NeuroImage, 101, 494–512."]}/> Subsequently, medial temporal lobe segmentation was conducted using ASHS via ITK-SNAP.<Citation text="[7]" content={["7. Yushkevich, P. A., Pluta, J. B., Wang, H., Xie, L., Ding, S.-L., Gertje, E. C., Mancuso, L., Kliot, D., Das, S. R., & Wolk, D. A. (2015). Automated volumetry and regional thickness analysis ofhippocampal subfields and medial temporal cortical structures in mild cognitive impairment. Human Brain Mapping, 36(1)."]}/> Individual connectomes and hippocampal white matter atlases were generated using MRtrix.<Citation text="[8]" content={["8. Tournier, J.-D., Smith, R., Raffelt, D., Tabbara, R., Dhollander, T., Pietsch, M., Christiaens, D., Jeurissen, B., Yeh, C.-H., & Connelly, A. (2019). MRtrix3: A fast, flexible and open softwareframework for medical image processing and visualisation. NeuroImage, 202, 116137."]}/></p>
        </div>
      </div>
      <div className='alogo'>
            <div className='supporttitle'>
              <h1>This project was made possible with funding and support from:</h1>
            </div>
            <div className='supportlogos'>
              <a href='http://macklab.utoronto.ca/'><img className='resultslogo' alt='The Mack Lab logo!' src={logo1} /></a>
              <a href='http://buddingmindslab.utoronto.ca/'><img className='resultslogo' alt='The Budding Minds Lab logo!' src={logo2} /></a>
              <a href='https://braincanada.ca/'><img className='resultslogo' alt='The Brain Canada logo!' src={logo3} /></a>
              <a href='https://cihr-irsc.gc.ca/e/193.html'><img className='resultslogo' alt='The CIHR logo!' src={logo4} /></a>
              <a href='https://www.nserc-crsng.gc.ca/index_eng.asp'><img className='resultslogo' alt='The NSERC logo!' src={logo5} /></a>
              <a href='https://vanier.gc.ca/en/home-accueil.html'><img className='resultslogo' alt='The Vanier logo!' src={logo6} /></a>
            </div>
      </div>
    </div>
  );
}

export default About;