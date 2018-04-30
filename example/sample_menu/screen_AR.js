/**
 * This is an example of a react component that use Augment
 * It is bundled as an App so you can test it quick
 */
import React, { Component } from 'react';
import { AppRegistry, StyleSheet, View, Text, Button } from 'react-native';
import { AugmentReact, AugmentReactPlayer } from 'react-native-augment';

var productToSearch = {
    identifier: "1",
    brand: "Rowenta",
    name: "AIR Force Extreme",
    ean: "3700342425321"
};

// Demo credentials, please replace with yours
var credentials = {
    id:  "357fee36746668573ceb2f5957c4869ee1a62a112639bac9b0fae43c7c431692",
    key: "80ae1420e164e0440d5329067bcdd953e9fa6c63b75c001c06d169a4f11268c5",
    vuforia: "ATQqCM7/////AAAAGXLs+GRi0UwXh0X+/qQL49dbZGym8kKo+iRtgC95tbJoCWjXXZihDl5pzxoca2JxLcYxBJ2pIeIE4dNcK0etMeb1746L7lq6vSFen43cS7P1P/HXjwHtUouV5Xus2U0F7WHUTKuO629jKFO13fBQczuY52UJcSEhsu9jHPMaupo5CpqQT3TFTQjlhzHhVXiVMEqq7RI+Edwh8TCSfGAbNRdbIELTfK+8YDYqwEHDbp62mFrs68YnCEQZDrpcLyC8WzFCVZtnUq3Cj3YBUfQ6gNnENYiuLf06gAAF/FcaF65VYveGRBbp3hpkqolX28bxPiUYNVknCSFXICPHciVntxF+rcHW5rrX7Cg/IVFGdNRF"
}

export default class AugmentReactExample extends Component {

    constructor(props) {
        super(props);
        AugmentReact.init(credentials);
        this.playerInstance = null;
        this.state = {
            loaderText: "Loading ...",
            loaderShow: true
        };
    }

    render() {
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
                        title="Buy"
                        onPress={this.buyProduct.bind(this)} />
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

        this.playerInstance = player;

        AugmentReact.checkIfModelDoesExistForUserProduct(productToSearch)
        .then((product) => {
          this.playerInstance.addProduct(product[0])
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
        if (!this.playerInstance) {
            console.log("playerInstance is null");
            return;
        }
        this.playerInstance.recenterProducts();
    }

    buyProduct() {
        alert('This is a demo :)');
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
