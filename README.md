# ezlogin

This is a boilerplate for easily creating a login mechanisnm. 

## Getting Started

You only have to implement `Ezlogin` mixin according to the database you are using and you are good to go. If the `EzloginUser` has too few attributes, you can inherit from it and use your own implementation. 

## Example

The example showcase how to create a `Mock` version of the `Ezlogin` and augments the `EzloginUser` with `firstName`, `lastName` and `notes`. 