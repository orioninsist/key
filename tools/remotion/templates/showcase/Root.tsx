import React from 'react';
import {Composition} from 'remotion';
import {Video} from './Video';

export const RemotionRoot: React.FC = () => (
  <Composition
    id="ShowcaseVideo"
    component={Video}
    width={1080}
    height={1920}
    fps={30}
    durationInFrames={150}
    defaultProps={{
      title: 'ORIONINSIST',
      subtitle: 'Digital Production',
      backgroundColor: '#09090b',
      textColor: '#ffffff',
      accentColor: '#22d3ee',
      durationInSeconds: 5
    }}
  />
);
