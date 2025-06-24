after Create Docker File Image ,start server
compile this flutter app

#Note in result_screen.dart RUN THIS if ur running androied studio elimenator
final uri = Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 3000,
        path: '/getPath',
        queryParameters: {
          'start': widget.from,
          'end': widget.to,
          'mode': 'precomputed',
        },
      ); 4

if real phone simulation :
final uri = Uri.http('192.168..:3000', '/getPath', { #your current ipcongig for desktop that runs tha server 
  'start': widget.from,
  'end': widget.to,
  'mode': 'precomputed',
});
