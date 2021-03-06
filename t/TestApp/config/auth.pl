use 5.012_001;
use warnings;

return [

'/user/only' => {
    modules => [
        'Session' => {
            key => 'is_user',
        },
    ],
    on_error => 'login',
},
'/user/mypage' => {
    modules => [
        'or' => [
            'Session' => {
                key => 'is_user',
            },
            'Session' => {
                key => 'is_dev',
            },
        ],
    ],
    on_error => 'login',
},
'/developer/only' => {
    modules => [
        'and' => [
            'Session' => {
                key => 'is_user',
            },
            'Session' => {
                key => 'is_dev',
            },
        ],
    ],
    on_error => 'login',
},

];
