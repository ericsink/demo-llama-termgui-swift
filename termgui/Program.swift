
// these are importing modules which are wrappers
// around .NET things.
// not sure I like the naming convention _Swift here.

import NETCore_Swift;
import NStack_Swift;
import Terminal_Gui_Swift;


// these typealias declarations are doing what in C#
// would be done with "using".

typealias Application = Terminal.Gui.Application;
typealias StatusBar = Terminal.Gui.StatusBar;
typealias StatusItem = Terminal.Gui.StatusItem;
typealias Pos = Terminal.Gui.Pos;
typealias Dim = Terminal.Gui.Dim;
typealias Key = Terminal.Gui.Key;
typealias MenuBar = Terminal.Gui.MenuBar;
typealias MenuBarItem = Terminal.Gui.MenuBarItem;
typealias MenuItem = Terminal.Gui.MenuItem;
typealias FrameView = Terminal.Gui.FrameView;
typealias Colors = Terminal.Gui.Colors;
typealias MessageBox = Terminal.Gui.MessageBox;
typealias Action = NETCore_Swift.System.Action;
typealias DateTime = NETCore_Swift.System.DateTime;
typealias Console = NETCore_Swift.System.Console;
typealias Color = Terminal.Gui.Color;
typealias GraphView = Terminal.Gui.GraphView;
typealias ClrString = NETCore_Swift.System.String;


// a function to convert a .NET string to NStack.ustring

func N(_ s : ClrString) -> NStack.ustring {
    return try! NStack.ustring.Make(s);
}


// the following code came from the UICatalog sample in
// the Terminal.Gui repo, ported to Swift.

func create_graph() throws -> FrameView {
    let graphView = try! Terminal.Gui.GraphView();
        graphView.CanFocus = true;
        graphView.ColorScheme = Colors.Base;
        graphView.Visible = true;
        graphView.X = try Pos.At(0);
        graphView.Y = try Pos.At(0);
        graphView.Width = try Dim.Fill(1);
        graphView.Height = try Dim.Fill(1);

    try graphView.Reset();

    let black = try Application.Driver.MakeAttribute (graphView.ColorScheme.Normal.Foreground, Color.Black);
    let cyan = try Application.Driver.MakeAttribute (Color.BrightCyan, Color.Black);
    let magenta = try Application.Driver.MakeAttribute (Color.BrightMagenta, Color.Black);
    let red = try Application.Driver.MakeAttribute (Color.BrightRed, Color.Black);

    // TODO figure out issues with System.Nullable
    //graphView.GraphColor = try NETCore_Swift.System.Nullable_1<Terminal.Gui.Attribute>(value: black);

    let series = try Terminal.Gui.Graphs.MultiBarSeries (numberOfBarsPerCategory: 3, barsEvery: 2, spacing: 0.25, colors: [ magenta, cyan, red ]);

    let stiple = Application.Driver.Stipple;

    try series.AddBars ("'96", stiple, [ 5900, 9000, 14000 ]);
    try series.AddBars ("'97", stiple, [ 6100, 9200, 14800 ]);
    try series.AddBars ("'98", stiple, [ 6000, 9300, 14600 ]);
    try series.AddBars ("'99", stiple, [ 6100, 9400, 14950 ]);
    try series.AddBars ("'00", stiple, [ 6200, 9500, 15200 ]);
    try series.AddBars ("'01", stiple, [ 6250, 9900, 16000 ]);
    try series.AddBars ("'02", stiple, [ 6600, 11000, 16700 ]);
    try series.AddBars ("'03", stiple, [ 7000, 12000, 17000 ]);

    graphView.CellSize = try Terminal.Gui.PointF (x: 0.25, y: 1000);

    // TODO need to implement a better solution for interfaces.
    // below, Series.Add() wants an ISeries.
    // on the .NET side, MultiBarSeries implements ISeries.
    // this side doesn't know that.
    // to bindgen gives us a method to "cast" it.
    try graphView.Series.Add (series.MultiBarSeries_to_ISeries());

    graphView.MarginLeft = 3;
    graphView.MarginBottom = 1;

    let f_label = try Terminal.Gui.Graphs.LabelGetterDelegate(
        { 
            (v : Terminal.Gui.Graphs.AxisIncrementToRender?) in
            // TODO implement string concatenation with + operator
            return try! ClrString.Concat(
                "$",
                try! NETCore_Swift.System.Single(val: v!.Value / 1000.0).ToString("N0"),
                "k"
                );
        });
    graphView.AxisY.LabelGetter = f_label;

    // Do not show x axis labels (bars draw their own labels)
    graphView.AxisX.Increment = 0;
    graphView.AxisX.ShowLabelsEvery = 0;

    // TODO figure out issues with System.Nullable
    //graphView.AxisX.Minimum = try NETCore_Swift.System.Nullable_1<Float>(value: 0.0);
    //graphView.AxisY.Minimum = try NETCore_Swift.System.Nullable_1<Float>(value: 0.0);

#if false // TODO ElementAt is an extension method
    let legend = try Terminal.Gui.Graphs.LegendAnnotation (legendBounds: Terminal.Gui.Rect (x: graphView.Bounds.Width - 20, y: 0, width: 20, height: 5));
    try legend.AddEntry (Terminal.Gui.Graphs.GraphCellToRender (rune: stiple, color: series.SubSeries.ElementAt (0).OverrideBarColor), "Lower Third");
    try legend.AddEntry (Terminal.Gui.Graphs.GraphCellToRender (rune: stiple, color: series.SubSeries.ElementAt (1).OverrideBarColor), "Middle Third");
    try legend.AddEntry (Terminal.Gui.Graphs.GraphCellToRender (rune: stiple, color: series.SubSeries.ElementAt (2).OverrideBarColor), "Upper Third");
    try graphView.Annotations.Add (legend.LegendAnnotation_to_IAnnotation());
#endif

    try graphView.SetNeedsDisplay ();

    let frame = try! FrameView(title: N("Graph"));
    try frame.Add(graphView);

    return frame;
}

try Application.Init(nil, nil);

let f_close = try Action({ () in try! Application.RequestStop()});
let f_about = try Action({ () in try! MessageBox.Query(N("About Llama Swift"), N("Hola"), [ N("_OK") ]) });

let menu = try MenuBar(
    menus :
    [
    try MenuBarItem(
        title: N("_File"),
        children: [
        try MenuItem(title: N("_Quit"), help: N(""), action: f_close, canExecute: nil, parent: nil, shortcut: Key.Null),
        ],
        parent: nil
        ),
    try MenuBarItem (title: N("_About..."), help: nil, action: f_about, canExecute: nil, parent: nil, shortcut: Key.Null),
    ]
    );

let topPane = try! FrameView(title: N("Top Pane"));
    topPane.X = try Pos.At(0);
    topPane.Y = try Pos.At(1);
    topPane.Width = try Dim.Fill(0);
    topPane.Height = try Dim.Sized(8);
    topPane.CanFocus = true;
    topPane.ColorScheme = Colors.Base;

let longDate = try! Terminal.Gui.DateField(date: DateTime.Now);
    longDate.X = try Pos.Center();
    longDate.Y = try Pos.At(2);
    longDate.IsShortFormat = false;
    longDate.ReadOnly = false;
try topPane.Add(longDate);

let tf = try! Terminal.Gui.TextField();
    tf.X = try Pos.Center();
    tf.Y = try Pos.At(4);
    tf.Width = try Dim.Sized(20);
try topPane.Add(tf);

let lab_magenta = try Terminal.Gui.Label (text: N("Magenta"));
    lab_magenta.X = try Pos.At(4);
    lab_magenta.Y = try Pos.At(2);
    lab_magenta.Width = try Dim.Sized(10);
    lab_magenta.Height = try Dim.Sized(3);
    let scheme_magenta = try Terminal.Gui.ColorScheme();
        scheme_magenta.Normal = try Terminal.Gui.Attribute(foreground: Color.White, background: Color.Magenta);
    lab_magenta.ColorScheme = scheme_magenta;
try topPane.Add (lab_magenta);

let lab_cyan = try Terminal.Gui.Label (text: N("Cyan"));
    lab_cyan.X = try Pos.At(16);
    lab_cyan.Y = try Pos.At(2);
    lab_cyan.Width = try Dim.Sized(10);
    lab_cyan.Height = try Dim.Sized(3);
    let scheme_cyan = try Terminal.Gui.ColorScheme();
        scheme_cyan.Normal = try Terminal.Gui.Attribute(foreground: Color.White, background: Color.Cyan);
    lab_cyan.ColorScheme = scheme_cyan;
try topPane.Add (lab_cyan);

// ----

let mainPane = try create_graph();
    mainPane.X = try Pos.At(0);
    mainPane.Y = try Pos.At(9);
    mainPane.Width = try Dim.Fill(0);
    mainPane.Height = try Dim.Fill(1);

let statusBar = try! StatusBar();
    statusBar.Visible = true;
    statusBar.Items =
        [
        try StatusItem(shortcut: Key.Null, title: NStack.ustring.Make("Demo of Swift, compiled for the CLR, using Terminal.Gui"), action: nil),
        ];

try Application.Top.Add(menu);
try Application.Top.Add(topPane);
try Application.Top.Add(mainPane);
try Application.Top.Add(statusBar);

try Application.Run(nil);

