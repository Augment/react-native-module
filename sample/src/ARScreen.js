/**
 * This is an example of a react component that use Augment
 * It is bundled as an App so you can test it quick
 */
import React, { Component } from 'react';
import { AppRegistry, StyleSheet, View, Text, Button, NativeEventEmitter, NativeModules } from 'react-native';
import { AugmentPlayerSDK, AugmentPlayer } from 'react-native-augment';
import Toast, {DURATION} from 'react-native-easy-toast'

export default class ARScreen extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            loaderText: "Loading ...",
            loaderShow: true
        };
    }

    componentDidMount() {
        this.augmentPlayer.create();
    }

    render() {
        let displayMode = this.state.loaderShow ? "flex" : "none";
        return (
            <View style={styles.container} pointerEvents={'none','box-none'}>
                <AugmentPlayer style={styles.augmentPlayer}
                    ref={ref => { this.augmentPlayer = ref; }}
                    onPlayerReady={this.business.bind(this)}
                    onInitializationFailed={this.error.bind(this)}
                    loaderCallback={this.loader.bind(this)}
                    onTrackingStatusChanged={this.onTrackingStatusChanged.bind(this)}
                    onModelGesture={this.onModelGesture.bind(this)}
                />
                <View style={styles.loaderContainer} pointerEvents={'none','box-none'}>
                    <Text style={[styles.loader, {display: displayMode}]}>
                        {this.state.loaderText}
                    </Text>
                </View>
                <View style={styles.buttonContainer}>
                    <Button style={styles.button}
                        title="Center"
                        onPress={this.centerProduct.bind(this)} />
                    <Button style={styles.button}
                        title="Take Screenshot"
                        onPress={this.takeScreenshot.bind(this)} />
                </View>
                <Toast ref="toast"/>
            </View>
        );
    }

    loader(loaderStatus) {
        this.setState({
            loaderShow: loaderStatus.show,
            loaderText: "Loading " + loaderStatus.progress + "%"
        });
    }

    error() {
        console.log("error");
    }

    business(player, error) {
        if (error) {
            this.refs.toast.show(error.toString());
            return;
        }

        const { params } = this.props.navigation.state;
        productToSearch = params.productToSearch

        AugmentPlayerSDK.checkIfModelDoesExistForUserProduct(productToSearch)
        .then((product) => {
          player.addProduct(product)
          .then(() => {
              console.log("The product has been added to the ARView");
          })
          .catch((error) => {
              this.refs.toast.show(error.toString());
          });
        })
        .catch((error) => {
            this.refs.toast.show(error.toString());
        })
    }

    centerProduct() {
      this.augmentPlayer.recenterProducts()
      .catch((error) => {
          this.refs.toast.show(error.toString());
      });
    }

    takeScreenshot() {
        this.augmentPlayer.takeScreenshot()
        .then((filePath) => {
          console.log(filePath)
          alert(`Screenshot saved at ${filePath}`);
        })
        .catch((error) => {
          this.refs.toast.show(error.toString());
        });
    }

    onTrackingStatusChanged = ({ status, message }) => {
      switch (status) {
        case AugmentPlayer.Constants.TrackingStatus.error:
          console.log('An error occured during tracking: ' + message);
          break;
        case AugmentPlayer.Constants.TrackingStatus.featuresDetected:
          console.log('Tracking state changed to FeaturesDetected');
          break;
        case AugmentPlayer.Constants.TrackingStatus.initializing:
          console.log('Tracking state changed to Initializing');
          break;
        case AugmentPlayer.Constants.TrackingStatus.limitedExcessiveMotion:
          console.log('Tracking state changed to LimitedExcessiveMotion');
          break;
        case AugmentPlayer.Constants.TrackingStatus.limitedInsufficientFeatures:
          console.log('Tracking state changed to LimitedInsufficientFeatures');
          break;
        case AugmentPlayer.Constants.TrackingStatus.limitedRelocalizing:
          console.log('Tracking state changed to LimitedRelocalizing');
          break;
        case AugmentPlayer.Constants.TrackingStatus.normal:
          console.log('Tracking state changed to Normal');
          break;
        case AugmentPlayer.Constants.TrackingStatus.notAvailable:
          console.log('Tracking state changed to NotAvailable');
          break;
        case AugmentPlayer.Constants.TrackingStatus.planeDetected:
          console.log('Tracking state changed to PlaneDetected');
          break;
        case AugmentPlayer.Constants.TrackingStatus.trackerDetected:
          console.log('Tracking state changed to TrackerDetected');
          break;
        default:
          console.log("onTrackingStatusChanged" + status)
      }
    }

    onModelGesture = (event) => {
      switch (event.gesture) {
        case AugmentPlayer.Constants.ModelGesture.added:
          console.log('Model with uuid ' + event.model_uuid + " has been placed");
          break;
        case AugmentPlayer.Constants.ModelGesture.translated:
          console.log('Model with uuid ' + event.model_uuid + " has been translated");
          break;
        case AugmentPlayer.Constants.ModelGesture.rotated:
          console.log('Model with uuid ' + event.model_uuid + " has been rotated");
          break;
      }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: "column",
        backgroundColor: "lightgray"
    },
    augmentPlayer: {
        position: "absolute",
        top: 0,
        bottom: 0,
        left: 0,
        right: 0
    },
    loaderContainer: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center"
    },
    loader: {
        backgroundColor: "white",
        padding: 16,
        borderRadius: 8
    },
    buttonContainer: {
        flex: 0,
        margin: 8,
        borderRadius: 5,
        flexDirection: "row",
        justifyContent: "space-around"
    },
    button: {
        flex: 1,
        height: 48,
        backgroundColor: "skyblue"
    }
});
