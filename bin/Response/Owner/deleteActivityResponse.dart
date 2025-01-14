import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import '../../RespnseMsg/ResponseMsg.dart';
import '../../Services/Supabase/supabaseEnv.dart';

deleteActivityByIdResponse(Request req , String id) async {
  try {
    
      final jwt = JWT.decode(req.headers["authorization"]!);
      final supabase = SupabaseEnv().supabase;
      
      final userId = (await supabase
          .from("users")
          .select("id")
          .eq("id_auth", jwt.payload["sub"]))[0]["id"];

      final owner_id =  (await supabase
          .from("owners")
          .select("id")
          .eq("user_id", userId))[0]["id"]; 

    await supabase 
            .from("activities")
            .delete()
            .eq("owner_id" , owner_id)
            .eq("id", id);

      return ResponseMsg().successResponse(
        msg: "Deleted successfully",
      );
  } catch (error) {
    return ResponseMsg().errorResponse(msg: error.toString());
  }
}

