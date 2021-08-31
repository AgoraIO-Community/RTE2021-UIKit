import React, {useState} from 'react';
import AgoraUIKit, {VideoRenderMode, PropsInterface} from 'agora-rn-uikit';
import {SafeAreaView, Text, TouchableOpacity} from 'react-native';

const App = () => {
  const [videoCall, setVideoCall] = useState(true);
  const props: PropsInterface = {
    rtcProps: {
      appId: YourAgoraAppId,
      channel: 'test',
    },
    styleProps: {
      iconSize: 30,
      theme: '#ffffffee',
      videoMode: {
        max: VideoRenderMode.Hidden,
        min: VideoRenderMode.Hidden,
      },
      overlayContainer: {
        backgroundColor: '#20212433',
        opacity: 1,
      },
      localBtnStyles: {
        muteLocalVideo: btnStyle,
        muteLocalAudio: btnStyle,
        switchCamera: btnStyle,
        endCall: {
          borderRadius: 1000,
          width: 50,
          height: 50,
          backgroundColor: '#e43',
          borderWidth: 0,
        },
      },
      localBtnContainer: {
        bottom: 100,
        flexDirection: 'row-reverse',
      },
      maxViewRemoteBtnContainer: {
        top: 0,
        alignSelf: 'flex-end',
      },
      minViewContainer: {
        bottom: 170,
        top: undefined,
        height: '15%',
        width: '100%',
      },
      minViewStyles: {
        height: '100%',
        width: 150,
      },
      maxViewStyles: {
        height: '60%',
      },
      UIKitContainer: {height: '94%', margin: '5%', backgroundColor: '#202124'},
    },
    callbacks: {
      EndCall: () => setVideoCall(false),
    },
  };

  return (
    <SafeAreaView style={{backgroundColor: '#202124'}}>
      <Text style={textStyle}>RTE 2021</Text>
      {videoCall ? (
        <>
          <AgoraUIKit
            styleProps={props.styleProps}
            rtcProps={props.rtcProps}
            callbacks={props.callbacks}
          />
        </>
      ) : (
        <TouchableOpacity
          style={startButton}
          onPress={() => setVideoCall(true)}>
          <Text style={{...textStyle, width: '50%'}}>Start Call</Text>
        </TouchableOpacity>
      )}
    </SafeAreaView>
  );
};

const textStyle = {
  color: '#fff',
  paddingTop: 30,
  fontSize: 22,
  textAlign: 'center',
  textAlignVertical: 'center',
};

const btnStyle = {
  borderRadius: 100,
  width: 40,
  elevation: 100,
  height: 40,
  backgroundColor: '#333',
  borderWidth: 0,
};

const startButton = {
  justifyContent: 'center',
  alignItems: 'center',
  alignContent: 'center',
  height: '90%',
  marginBottom: 15,
};

export default App;
