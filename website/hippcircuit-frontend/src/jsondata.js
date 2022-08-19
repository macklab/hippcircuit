import TestFile from './downloads/test.zip';

import ALLTRACTS from './models/Full_Model.glb';
import LCA1SUB from './models/L_CA1_SUB.glb';
import LCA2CA3CA1 from './models/L_CA2CA3_CA1.glb';
import LCA4DGCA2CA3 from './models/L_CA4DG_CA2CA3.glb';
import LERCCA1 from './models/L_ERC_CA1.glb';
import LSUBCA4DG from './models/L_SUB_CA4DG.glb';
import LSUBERC from './models/L_SUB_ERC.glb';
import RCA1SUB from './models/R_CA1_SUB.glb';
import RCA2CA3CA1 from './models/R_CA2CA3_CA1.glb';
import RCA4DGCA2CA3 from './models/R_CA4DG_CA2CA3.glb';
import RERCCA1 from './models/R_ERC_CA1.glb';
import RSUBCA4DG from './models/R_SUB_CA4DG.glb';
import RSUBERC from './models/R_SUB_ERC.glb'

import logo1im from './images/MackLabLogo.png';
import logo2im from './images/BuddingMindsLogo.png';
import logo3im from './images/BrainCanadaLogoDark.png';
import logo4im from './images/CIHRLogo.jpg';
import logo5im from './images/NSERC_logo.png';
import logo6im from './images/Vanier_logo.png';
import logo7im from './images/blender_logo.png';

import ima1 from './images/artim1.png';
import ima2 from './images/artim2.png';
import ima3 from './images/artim3.png';
import ima4 from './images/artim4.png';
import ima5 from './images/artim5.png';
import ima6 from './images/artim6.png';
import ima7 from './images/artim7.png';
import ima8 from './images/artim8.png';
import ima9 from './images/artim9.png';

import VPstreamLCA2CA3CA1 from './images/results/violin_plots/stream_L_CA2CA3_L_CA1.png';
import VPstreamLCA2CA3CA4DG from './images/results/violin_plots/stream_L_CA2CA3_L_CA4DG.png';
import VPstreamLCA4DGSUB from './images/results/violin_plots/stream_L_CA4DG_L_subiculum.png';
import VPstreamLERCCA1 from './images/results/violin_plots/stream_L_ERC_L_CA1.png';
import VPstreamLERCSUB from './images/results/violin_plots/stream_L_ERC_L_subiculum.png';
import VPstreamLSUBCA1 from './images/results/violin_plots/stream_L_subiculum_L_CA1.png';
import VPstreamRCA2CA3CA1 from './images/results/violin_plots/stream_R_CA2CA3_R_CA1.png';
import VPstreamRCA2CA3CA4DG from './images/results/violin_plots/stream_R_CA2CA3_R_CA4DG.png';
import VPstreamRCA4DGSUB from './images/results/violin_plots/stream_R_CA4DG_R_subiculum.png';
import VPstreamRERCCA1 from './images/results/violin_plots/stream_R_ERC_R_CA1.png';
import VPstreamRERCSUB from './images/results/violin_plots/stream_R_ERC_R_subiculum.png';
import VPstreamRSUBCA1 from './images/results/violin_plots/stream_R_subiculum_R_CA1.png';


export const buttondata = [
    {
        id: 1,
        side: '',
        firstROI: 'All ROIs',
        secondROI: 'all ROIs',
        n: 3390,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for all ROIs',
        streamsViolin: null
      },
      {
        id: 2,
        side: 'Left',
        firstROI: 'CA1',
        secondROI: 'SUB',
        n: 283,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left CA1 to SUB',
        streamsViolin: VPstreamLSUBCA1
      },
      {
        id: 3,
        side: 'Left',
        firstROI: 'CA2CA3',
        secondROI: 'CA1',
        n: 44,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left CA2CA3 to CA1',
        streamsViolin: VPstreamLCA2CA3CA1
      },
      {
        id: 4,
        side: 'Left',
        firstROI: 'CA4DG',
        secondROI: 'CA2CA3',
        n: 163,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left CA4DG to CA2CA3',
        streamsViolin: VPstreamLCA2CA3CA4DG
      },
      {
        id: 5,
        side: 'Left',
        firstROI: 'ERC',
        secondROI: 'CA1',
        n: 128,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left ERC to CA1',
        streamsViolin: VPstreamLERCCA1
      },
      {
        id: 6,
        side: 'Left',
        firstROI: 'SUB',
        secondROI: 'CA4DG',
        n: 83,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left SUB to CA4DG',
        streamsViolin: VPstreamLCA4DGSUB
      },
      {
        id: 7,
        side: 'Left',
        firstROI: 'SUB',
        secondROI: 'ERC',
        n: 841,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Left SUB to ERC',
        streamsViolin: VPstreamLERCSUB
      },
      {
        id: 8,
        side: 'Right',
        firstROI: 'CA1',
        secondROI: 'SUB',
        n: 616,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right CA1 to SUB',
        streamsViolin: VPstreamRSUBCA1
      },
      {
        id: 9,
        side: 'Right',
        firstROI: 'CA2CA3',
        secondROI: 'CA1',
        n: 108,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right CA2CA3 to CA1',
        streamsViolin: VPstreamRCA2CA3CA1
      },
      {
        id: 10,
        side: 'Right',
        firstROI: 'CA4DG',
        secondROI: 'CA2CA3',
        n: 301,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right CA4DG to CA2CA3',
        streamsViolin: VPstreamRCA2CA3CA4DG
      },
      {
        id: 11,
        side: 'Right',
        firstROI: 'ERC',
        secondROI: 'CA1',
        n: 110,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right ERC to CA1',
        streamsViolin: VPstreamRERCCA1
      },
      {
        id: 12,
        side: 'Right',
        firstROI: 'SUB',
        secondROI: 'CA4DG',
        n: 33,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right SUB to CA4DG',
        streamsViolin: VPstreamRCA4DGSUB
      },
      {
        id: 13,
        side: 'Right',
        firstROI: 'SUB',
        secondROI: 'ERC',
        n: 680,
        downloadFile: TestFile,
        downloadName: 'TestFile1.zip',
        downloadText: 'Download data for Right SUB to ERC',
        streamsViolin: VPstreamRERCSUB
      }
];


export const cardData = [
    {
      id: 1,
      model: ALLTRACTS,
      side: 'Both',
      firstROI: 'All ROIs',
      secondROI: 'all ROIs',
      n: 3390
    },
    {
      id: 2,
      model: LCA1SUB,
      side: 'Left',
      firstROI: 'CA1',
      secondROI: 'SUB',
      n: 283
    },
    {
      id: 3,
      model: LCA2CA3CA1,
      side: 'Left',
      firstROI: 'CA2CA3',
      secondROI: 'CA1',
      n: 44
    },
    {
      id: 4,
      model: LCA4DGCA2CA3,
      side: 'Left',
      firstROI: 'CA4DG',
      secondROI: 'CA2CA3',
      n: 163
    },
    {
      id: 5,
      model: LERCCA1,
      side: 'Left',
      firstROI: 'ERC',
      secondROI: 'CA1',
      n: 128
    },
    {
      id: 6,
      model: LSUBCA4DG,
      side: 'Left',
      firstROI: 'SUB',
      secondROI: 'CA4DG',
      n: 83
    },
    {
      id: 7,
      model: LSUBERC,
      side: 'Left',
      firstROI: 'SUB',
      secondROI: 'ERC',
      n: 841
    },
    {
      id: 8,
      model: RCA1SUB,
      side: 'Right',
      firstROI: 'CA1',
      secondROI: 'SUB',
      n: 616
    },
    {
      id: 9,
      model: RCA2CA3CA1,
      side: 'Right',
      firstROI: 'CA2CA3',
      secondROI: 'CA1',
      n: 108
    },
    {
      id: 10,
      model: RCA4DGCA2CA3,
      side: 'Right',
      firstROI: 'CA4DG',
      secondROI: 'CA2CA3',
      n: 301
    },
    {
      id: 11,
      model: RERCCA1,
      side: 'Right',
      firstROI: 'ERC',
      secondROI: 'CA1',
      n: 110
    },
    {
      id: 12,
      model: RSUBCA4DG,
      side: 'Right',
      firstROI: 'SUB',
      secondROI: 'CA4DG',
      n: 33
    },
    {
      id: 13,
      model: RSUBERC,
      side: 'Right',
      firstROI: 'SUB',
      secondROI: 'ERC',
      n: 680
    },
];


export const logo1 = logo1im;

export const logo2 = logo2im;

export const logo3 = logo3im;

export const logo4 = logo4im;

export const logo5 = logo5im;

export const logo6 = logo6im;

export const logo7 = logo7im;


export const im1 = ima1;

export const im2 = ima2;

export const im3 = ima3;

export const im4 = ima4;

export const im5 = ima5;

export const im6 = ima6;

export const im7 = ima7;

export const im8 = ima8;

export const im9 = ima9;
