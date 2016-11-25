/*!
 * @file
 *   @brief ST16 Controller
 *   @author Gus Grubba <mavlink@grubba.com>
 *
 */

#pragma once

#include <QObject>
#include <QTimer>
#include <QLoggingCategory>
#include "m4def.h"
#include "m4util.h"

Q_DECLARE_LOGGING_CATEGORY(YuneecLog)

class IQGCApplication;

//-----------------------------------------------------------------------------
class TyphoonHCore : public QObject
{
    Q_OBJECT
public:
    TyphoonHCore(QObject* parent = NULL);
    ~TyphoonHCore();

    bool    init                    (IQGCApplication* pApp);

    enum {
        M4_STATE_NONE           = 0,
        M4_STATE_AWAIT          = 1,
        M4_STATE_BIND           = 2,
        M4_STATE_CALIBRATION    = 3,
        M4_STATE_SETUP          = 4,
        M4_STATE_RUN            = 5,
        M4_STATE_SIM            = 6,
        M4_STATE_FACTORY_CALI   = 7
    };

    int     getm4State              () { return _m4State; }
    void    getControllerLocation   (ControllerLocation& location);
    void    enterBindMode           ();

    static  int     byteArrayToInt  (QByteArray data, int offset, bool isBigEndian = false);
    static  float   byteArrayToFloat(QByteArray data, int offset);
    static  short   byteArrayToShort(QByteArray data, int offset, bool isBigEndian = false);

private slots:
    void    _bytesReady             (QByteArray data);
    void    _stateManager           ();
private:
    bool    _enterRun               ();
    bool    _exitRun                ();
    bool    _startBind              ();
    bool    _enterBind              ();
    bool    _exitBind               ();
    bool    _bind                   (int rxAddr);
    bool    _unbind                 ();
    void    _checkExitRun           ();
    void    _initSequence           ();
    bool    _queryBindState         ();
    bool    _sendRecvBothCh         ();
    bool    _setChannelSetting      ();
    bool    _syncMixingDataDeleteAll();
    bool    _syncMixingDataAdd      ();
    bool    _sendRxResInfo          ();
    bool    _setPowerKey            (int function);
    void    _handleBindResponse     ();
    void    _handleQueryBindResponse(QByteArray data);
    bool    _handleNonTypePacket    (m4Packet& packet);
    void    _handleRxBindInfo       (m4Packet& packet);
    void    _handleChannel          (m4Packet& packet);
    bool    _handleCommand          (m4Packet& packet);
    void    _switchChanged          (m4Packet& packet);
    void    _handleMixedChannelData (m4Packet& packet);
    void    _handControllerFeedback (m4Packet& packet);
signals:
    void    m4StateChanged             (int state);
    void    switchStateChanged         (int swId, int oldState, int newState);
    void    channelDataStatus          (QByteArray channelData);
    void    controllerLocationChanged  ();
private:
    M4SerialComm* _commPort;
    enum {
        STATE_NONE,
        STATE_ENTER_BIND_ERROR,
        STATE_EXIT_RUN,
        STATE_ENTER_BIND,
        STATE_START_BIND,
        STATE_UNBIND,
        STATE_BIND,
        STATE_QUERY_BIND,
        STATE_EXIT_BIND,
        STATE_RECV_BOTH_CH,
        STATE_SET_CHANNEL_SETTINGS,
        STATE_MIX_CHANNEL_DELETE,
        STATE_MIX_CHANNEL_ADD,
        STATE_SEND_RX_INFO,
        STATE_ENTER_RUN,
        STATE_RUNNING
    };
    int                 _state;
    int                 _responseTryCount;
    int                 _currentChannelAdd;
    int                 _m4State;
    RxBindInfo          _rxBindInfoFeedback;
    QTimer              _timer;
    ControllerLocation  _controllerLocation;
};
