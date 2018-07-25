/**
 * This is an example of a react component that use Augment
 * It is bundled as an App so you can test it quick
 */
import React, { Component } from 'react';
import { AppRegistry, StyleSheet, View, Text, Button, NativeEventEmitter, NativeModules } from 'react-native';
import { AugmentReact, AugmentReactPlayer } from 'react-native-augment';
import Toast, {DURATION} from 'react-native-easy-toast'

var productToSearch
var toog = false

export default class AugmentReactExample extends Component {

    constructor(props) {
        super(props);
        this.state = {
            loaderText: "Loading ...",
            loaderShow: true
        };
    }

    componentWillMount() {
        const { AugmentReactPlayerTrackingStatusEmitter, AugmentReactPlayerModelGestureEmitter } = NativeModules;
        this.trackingStatusEmitter = new NativeEventEmitter(NativeModules.AugmentReactPlayerTrackingStatusEmitter);
        this.modelGestureEmitter = new NativeEventEmitter(NativeModules.AugmentReactPlayerModelGestureEmitter);
        this.subscriptions = [
            // Connect to each tracking status event individually
            this.trackingStatusEmitter.addListener('Error',(data) => {
              this.refs.toast.show('Error');
                console.log('An error occured during tracking: ' + data);
            }),
            this.trackingStatusEmitter.addListener('FeaturesDetected',() => {
              this.refs.toast.show('FeaturesDetected');
                console.log('Tracking state changed to FeaturesDetected');
            }),
            this.trackingStatusEmitter.addListener('Initializing',() => {
              this.refs.toast.show('Initializing', DURATION.FOREVER);
                console.log('Tracking state changed to Initializing');
            }),
            this.trackingStatusEmitter.addListener('LimitedExcessiveMotion',() => {
              this.refs.toast.show('LimitedExcessiveMotion');
                console.log('Tracking state changed to LimitedExcessiveMotion');
            }),
            this.trackingStatusEmitter.addListener('LimitedInsufficientFeatures',() => {
              this.refs.toast.show('LimitedInsufficientFeatures');
                console.log('Tracking state changed to LimitedInsufficientFeatures');
            }),
            this.trackingStatusEmitter.addListener('LimitedRelocalizing',() => {
              this.refs.toast.show('LimitedRelocalizing');
                console.log('Tracking state changed to LimitedRelocalizing');
            }),
            this.trackingStatusEmitter.addListener('Normal',() => {
              this.refs.toast.show('Normal');
                console.log('Tracking state changed to Normal');
            }),
            this.trackingStatusEmitter.addListener('NotAvailable',() => {
              this.refs.toast.show('NotAvailable');
                console.log('Tracking state changed to NotAvailable');
            }),
            this.trackingStatusEmitter.addListener('PlaneDetected',() => {
              this.refs.toast.show('PlaneDetected');
                console.log('Tracking state changed to PlaneDetected');
            }),
            this.trackingStatusEmitter.addListener('TrackerDetected',() => {
              this.refs.toast.show('TrackerDetected');
                console.log('Tracking state changed to TrackerDetected');
            }),
            // Connect to each gesture event individually
            this.modelGestureEmitter.addListener('ModelAdded',(model3DUuid) => {
              this.refs.toast.show('ModelAdded');
                console.log('Model added with uuid ' + model3DUuid);
            }),
            this.modelGestureEmitter.addListener('ModelTranslated',(model3DUuid) => {
              this.refs.toast.show('ModelTranslated');
                console.log('Model translated with uuid ' + model3DUuid);
            }),
            this.modelGestureEmitter.addListener('ModelRotated',(model3DUuid) => {
              this.refs.toast.show('ModelRotated');
                console.log('Model rotated with uuid ' + model3DUuid);
            }),
        ]
    }

    componentWillUnmount() {
        this.subscriptions.forEach(function(subscription) {
            subscription.remove();
        });
    }

    render() {
        const { params } = this.props.navigation.state;
        productToSearch = params ? params.productToSearch : {
          identifier: "4",
          brand: "Apple",
          name: "Ipad"
                                                            };
        let displayMode = this.state.loaderShow ? "flex" : "none";

        return (
            <View style={styles.container} pointerEvents={'none','box-none'}>
                <AugmentReactPlayer style={styles.augmentPlayer}
                    onPlayerReady={this.business.bind(this)}
                    loaderCallback={this.loader.bind(this)}
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
        // Product and AR general loading
        // This is here to allow you to give feedback to your user
        // {progress: int, show: bool}
        console.log(loaderStatus);
        this.setState({
            loaderShow: loaderStatus.show,
            loaderText: "Loading " + loaderStatus.progress + "%"
        });
    }

    business(player, error) {
        if (error) {
            console.error(error);
            return;
        }

        AugmentReact.checkIfModelDoesExistForUserProduct(productToSearch)
        .then((product) => {
          AugmentReact.addProductToAugmentPlayer(product)
          .then(() => {
              console.log("The product has been added to the ARView");
          })
          .catch((error) => {
              console.error(error);
          });
        })
        .catch((error) => {
            console.error(error);
        })
    }

    centerProduct() {
      AugmentReact.recenterProducts()
      .catch((error) => {
          console.error(error);
      });
    }

    takeScreenshot() {
        AugmentReact.takeScreenshot()
        .then((filePath) => {
          console.log(filePath)
          alert(`Screenshot saved at ${filePath}`);
        })
        .catch((error) => {
            console.error(error);
        });
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

// Rename this regarding your project name
AppRegistry.registerComponent('AugmentReactExample', () => AugmentReactExample);
