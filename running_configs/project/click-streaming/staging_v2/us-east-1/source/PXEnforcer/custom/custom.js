const { PerimeterX } = require('../px/perimeterx');

const customInitCallback = () => {
    // call any functions you like on PX initialization here
    PerimeterX.SetAdditionalActivityHandler(null);
    PerimeterX.SetCustomRequestHandler(null);
    PerimeterX.SetEnrichCustomParamsFunction(null);
    PerimeterX.SetExtractUserIpFunction(null);
    PerimeterX.SetLoginSuccessfulCustomCallbackFunction(null);
};

module.exports = {
    customInitCallback
};