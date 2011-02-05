using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Microsoft.Xna.Framework.Media;
using Newtonsoft.Json;

namespace Ambiance
{
    class CurrentState
    {
        public String stateTimestamp { get; set; }
        public Dictionary<string, object> state { get; set; }
        public String takingOverClient { get; set; }
        public String takeoverTimestamp { get; set; }
    }

    public partial class MainPage : PhoneApplicationPage
    {
        // Costruttore
        public MainPage()
        {
            InitializeComponent();
        }

        private DownloadStringCompletedEventHandler firstStep;
        private UploadStringCompletedEventHandler secondStep;

        private void ReturnToThisPhone(object sender, RoutedEventArgs e)
        {
            firstStep = new DownloadStringCompletedEventHandler(DidDownloadCurrentState);
            secondStep = new UploadStringCompletedEventHandler(DidTakeOver);

            var x = new WebClient();
            x.DownloadStringCompleted += firstStep;
            x.DownloadStringAsync(new Uri("http://localhost:8008/services/music"));
        }

        private CurrentState currentState;

        private void DidDownloadCurrentState(object sender, DownloadStringCompletedEventArgs e)
        {
            WebClient w = (WebClient)sender;
            this.currentState = (CurrentState) JsonConvert.DeserializeObject(e.Result, typeof(CurrentState));

            w.DownloadStringCompleted -= firstStep;
            w.UploadStringCompleted += secondStep;

            w.UploadStringAsync(new Uri("http://localhost:8008/services/music/takeover"), "{\"takingOverClient\": \"WP7\"}");
        }

        private void DidTakeOver(object sender, UploadStringCompletedEventArgs e)
        {
            var m = new MediaLibrary();

            string name = (string) currentState.state["trackName"], album = (string) currentState.state["albumName"];

            var i = -1;
            for (int j = 0; j < m.Songs.Count; j++)
            {
                if (m.Songs[j].Name == name && m.Songs[j].Album != null && m.Songs[j].Album.Name == name)
                {
                    i = j;
                    break;
                }
            }

            if (i != -1)
                MediaPlayer.Play(m.Songs, i);
        }
    }
}