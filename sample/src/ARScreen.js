/**
 * This is an example of a react component that use Augment
 * It is bundled as an App so you can test it quick
 */
import React, { Component } from 'react';
import { AppRegistry, StyleSheet, View, Text, Button, NativeEventEmitter, NativeModules } from 'react-native';
import { AugmentPlayerSDK, AugmentPlayer } from 'react-native-augment';
import Toast, {DURATION} from 'react-native-easy-toast'

export default class ARScreen extends Component {

    constructor(props) {
        super(props);
        this.state = {
            loaderText: "Loading ...",
            loaderShow: true
        };
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
            console.error(error);
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
              console.error(error);
          });
        })
        .catch((error) => {
            console.error(error);
        })
    }

    centerProduct() {
      this.augmentPlayer.recenterProducts()
      .catch((error) => {
          console.error(error);
      });
    }

    takeScreenshot() {
        this.augmentPlayer.takeScreenshot()
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
