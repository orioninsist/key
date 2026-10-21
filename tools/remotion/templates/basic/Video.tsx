import React from 'react';
import {
  AbsoluteFill,
  interpolate,
  spring,
  useCurrentFrame,
  useVideoConfig
} from 'remotion';

type VideoProps = {
  title: string;
  subtitle: string;
  backgroundColor: string;
  textColor: string;
  accentColor: string;
  durationInSeconds: number;
};

export const Video: React.FC<VideoProps> = ({
  title,
  subtitle,
  backgroundColor,
  textColor,
  accentColor
}) => {
  const frame = useCurrentFrame();
  const {fps, durationInFrames} = useVideoConfig();

  const entrance = spring({
    frame,
    fps,
    config: {damping: 200}
  });

  const fadeIn = interpolate(
    frame,
    [0, 15],
    [0, 1],
    {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'}
  );

  const fadeOut = interpolate(
    frame,
    [Math.max(0, durationInFrames - 15), durationInFrames],
    [1, 0],
    {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'}
  );

  return (
    <AbsoluteFill
      style={{
        backgroundColor,
        justifyContent: 'center',
        alignItems: 'center',
        fontFamily: 'Arial, sans-serif',
        padding: 70,
        boxSizing: 'border-box'
      }}
    >
      <div
        style={{
          width: '100%',
          textAlign: 'center',
          opacity: Math.min(fadeIn, fadeOut),
          transform: `scale(${0.85 + entrance * 0.15})`
        }}
      >
        <div
          style={{
            width: 150,
            height: 8,
            borderRadius: 10,
            backgroundColor: accentColor,
            margin: '0 auto 50px'
          }}
        />
        <h1
          style={{
            color: textColor,
            fontSize: 92,
            fontWeight: 900,
            overflowWrap: 'anywhere',
            margin: 0
          }}
        >
          {title}
        </h1>
        <p
          style={{
            color: accentColor,
            fontSize: 42,
            marginTop: 30
          }}
        >
          {subtitle}
        </p>
      </div>
    </AbsoluteFill>
  );
};
