Object.defineProperty(exports, '__esModule', { value: true });

var perimeterx = require('./px/perimeterx');
var config = require('./custom/config');
var custom = require('./custom/custom');

perimeterx.PerimeterX.Initialize(config.pxConfig, custom.customInitCallback);

const handler = (event, context, callback) => {
    if (!perimeterx.PerimeterX.config.px_sync_activities_enabled) {
        context.callbackWaitsForEmptyEventLoop = false;
    }
    const req = event.Records[0].cf.request;
    perimeterx.PerimeterX.Enforce(req, (err, { data, res }) => {
        if (res) {
            const response = perimeterx.PerimeterX.GenerateBlockResponse(res);
            callback(null, response);
        } else {
            const request = perimeterx.PerimeterX.PreparePassRequest(req, data);
            callback(null, request);
        }
    });
};

exports.handler = handler;
