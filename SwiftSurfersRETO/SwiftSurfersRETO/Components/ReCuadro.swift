import SwiftUI

struct ReCuadro: View {
    let servicio: Servicio2
    
    var estado: EstadoServicio2 {
        EstadoServicio2(id: servicio.idEstatus)
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                
                HStack {
                    Image(estado.Image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                    
                    Text(servicio.hora)
                        .font(.system(size: 26))
                    
                    Spacer()
                    
                    Text(estado.nombre)
                        .font(.caption).bold()
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(estado.color.opacity(0.15))
                        .foregroundStyle(estado.color)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
    
                Spacer()
                
                HStack {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    
                    Text("\(servicio.nombreSocio) \(servicio.apellidoPaternoSocio) \(servicio.apellidoMaternoSocio)")
                        .font(.system(size: 20))
                    
                    Spacer()
                }
                
                Spacer()
                
                // Origen
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading) {
                        Text("Origen")
                            .font(.system(size: 20)).bold()
                        Text(servicio.origen)
                            .font(.system(size: 18))
                    }
                    Spacer()
                }
                
                Spacer()
                
                // Destino
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading) {
                        Text("Destino")
                            .font(.system(size: 20)).bold()
                        Text(servicio.destino)
                            .font(.system(size: 18))
                    }
                    Spacer()
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.15))
        .frame(width: 360, height: 230)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

#Preview {
    ReCuadro(servicio: .ejemplo)
}
