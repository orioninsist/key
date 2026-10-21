import React from 'react';
import {Composition} from 'remotion';
import {Video} from './Video';

export const RemotionRoot: React.FC = () => {
  return (
    <Composition
      id="BasicVideo"
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
      calculateMetadata={({props}) => {
        const seconds = Number(props.durationInSeconds);
        if (!Number.isFinite(seconds) || seconds <= 0) {
          throw new Error('durationInSeconds pozitif olmali');
        }
        return {
          durationInFrames: Math.ceil(seconds * 30)
        };
      }}
    />
  );
};
