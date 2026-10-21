import React from 'react';
import {
  AbsoluteFill,
  interpolate,
  useCurrentFrame,
  useVideoConfig
} from 'remotion';
import {loadFont} from '@remotion/google-fonts/Inter';
import {Box} from '@remotion/rough-notation';
import {
  TransitionSeries,
  linearTiming
} from '@remotion/transitions';
import {fade} from '@remotion/transitions/fade';

const {fontFamily} = loadFont('normal', {
  weights: ['400', '700', '900'],
  subsets: ['latin']
});

type VideoProps = {
  title: string;
  subtitle: string;
  backgroundColor: string;
  textColor: string;
  accentColor: string;
  durationInSeconds: number;
};

const Scene: React.FC<{
  heading: string;
  caption: string;
  background: string;
  foreground: string;
  accent: string;
  annotation?: boolean;
}> = ({
  heading,
  caption,
  background,
  foreground,
  accent,
  annotation = false
}) => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();

  const opacity = interpolate(
    frame,
    [0, 12],
    [0, 1],
    {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'}
  );

  const progress = interpolate(
    frame,
    [12, 35],
    [0, 1],
    {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'}
  );

  return (
    <AbsoluteFill
      style={{
        backgroundColor: background,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 65,
        boxSizing: 'border-box',
        fontFamily
      }}
    >
      <div
        style={{
          color: accent,
          fontSize: 26,
          letterSpacing: 9,
          marginBottom: 65,
          fontWeight: 700
        }}
      >
        DIGITAL PRODUCTION
      </div>

      <div
        style={{
          opacity,
          color: foreground,
          fontSize: 86,
          fontWeight: 900,
          textAlign: 'center',
          overflowWrap: 'anywhere',
          lineHeight: 1.15
        }}
      >
        {annotation ? (
          <Box
            progress={progress}
            color={accent}
            strokeWidth={6}
            iterations={2}
            padding={{
              left: 16,
              right: 16,
              top: 12,
              bottom: 12
            }}
          >
            {heading}
          </Box>
        ) : (
          heading
        )}
      </div>

      <div
        style={{
          marginTop: 75,
          fontSize: 39,
          color: accent,
          textAlign: 'center',
          opacity
        }}
      >
        {caption}
      </div>

      <div
        style={{
          position: 'absolute',
          bottom: 110,
          fontSize: 23,
          color: foreground,
          opacity: 0.45,
          letterSpacing: 5
        }}
      >
        ORIONINSIST • {fps} FPS
      </div>
    </AbsoluteFill>
  );
};

export const Video: React.FC<VideoProps> = ({
  title,
  subtitle,
  backgroundColor,
  textColor,
  accentColor
}) => {
  return (
    <TransitionSeries>
      <TransitionSeries.Sequence durationInFrames={85}>
        <Scene
          heading={title}
          caption={subtitle}
          background={backgroundColor}
          foreground={textColor}
          accent={accentColor}
          annotation
        />
      </TransitionSeries.Sequence>

      <TransitionSeries.Transition
        presentation={fade()}
        timing={linearTiming({durationInFrames: 20})}
      />

      <TransitionSeries.Sequence durationInFrames={85}>
        <Scene
          heading="CREATE MORE"
          caption="Motion • Design • Impact"
          background="#101827"
          foreground={textColor}
          accent={accentColor}
          annotation
        />
      </TransitionSeries.Sequence>
    </TransitionSeries>
  );
};
