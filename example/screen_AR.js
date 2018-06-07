/**
 * This is an example of a react component that use Augment
 * It is bundled as an App so you can test it quick
 */
import React, { Component } from 'react';
import { AppRegistry, StyleSheet, View, Text, Button } from 'react-native';
import { AugmentReact, AugmentReactPlayer } from 'react-native-augment';

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

    render() {
        const { params } = this.props.navigation.state;
        productToSearch = params ? params.productToSearch : {
                                                              identifier: "1",
                                                              brand: "Rowenta",
                                                              name: "AIR Force Extreme",
                                                              ean: "3700342425321"
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
